"""OpenCode provider implementation."""

from __future__ import annotations

from collections.abc import Iterator
from typing import Any

from core.anthropic import append_request_id, iter_provider_stream_error_sse_events
from core.anthropic.native_sse_block_policy import (
    NativeSseBlockPolicyState,
    is_terminal_openrouter_done_event,
    parse_native_sse_event,
    transform_native_sse_block_event,
)
from providers.anthropic_messages import AnthropicMessagesTransport, StreamChunkMode
from providers.base import ProviderConfig
from providers.defaults import OPENCODE_DEFAULT_BASE
from providers.model_listing import (
    ProviderModelInfo,
    extract_openai_model_ids,
)

_ANTHROPIC_VERSION = "2023-06-01"


class OpenCodeProvider(AnthropicMessagesTransport):
    """OpenCode provider using the native Anthropic-compatible messages API."""

    stream_chunk_mode: StreamChunkMode = "event"

    def __init__(self, config: ProviderConfig):
        super().__init__(
            config,
            provider_name="OPENCODE",
            default_base_url=OPENCODE_DEFAULT_BASE,
        )

    def _build_request_body(
        self, request: Any, thinking_enabled: bool | None = None
    ) -> dict:
        """Build request body for OpenCode's messages API."""
        from core.anthropic.native_messages_request import (
            build_base_native_anthropic_request_body,
        )
        from config.constants import ANTHROPIC_DEFAULT_MAX_OUTPUT_TOKENS

        thinking_enabled = self._is_thinking_enabled(request, thinking_enabled)
        return build_base_native_anthropic_request_body(
            request,
            default_max_tokens=ANTHROPIC_DEFAULT_MAX_OUTPUT_TOKENS,
            thinking_enabled=thinking_enabled,
        )

    def _request_headers(self) -> dict[str, str]:
        """Return OpenCode's Anthropic-compatible messages headers."""
        return {
            "Accept": "text/event-stream",
            "Authorization": f"Bearer {self._api_key}",
            "Content-Type": "application/json",
            "anthropic-version": _ANTHROPIC_VERSION,
        }

    def _model_list_headers(self) -> dict[str, str]:
        """Return OpenCode's OpenAI-compatible model-list headers."""
        return {"Authorization": f"Bearer {self._api_key}"}

    def _extract_model_ids_from_model_list_payload(
        self, payload: Any
    ) -> frozenset[str]:
        """Extract model IDs from OpenCode's model list response."""
        return extract_openai_model_ids(payload, provider_name=self._provider_name)

    def _extract_model_infos_from_model_list_payload(
        self, payload: Any
    ) -> frozenset[ProviderModelInfo]:
        """Extract model infos from OpenCode's model list response."""
        model_ids = self._extract_model_ids_from_model_list_payload(payload)
        return frozenset(
            ProviderModelInfo(model_id=model_id, supports_thinking=None)
            for model_id in model_ids
        )

    def _new_stream_state(self, request: Any, *, thinking_enabled: bool) -> Any:
        """Create per-stream state for thinking block filtering."""
        return NativeSseBlockPolicyState()

    def _transform_stream_event(
        self,
        event: str,
        state: Any,
        *,
        thinking_enabled: bool,
    ) -> str | None:
        """Drop provider-specific terminal noise and hidden thinking events."""
        if isinstance(state, NativeSseBlockPolicyState):
            event_name, data_text = parse_native_sse_event(event)
            if state.message_stopped or is_terminal_openrouter_done_event(
                event_name, data_text
            ):
                return None
            if event_name == "message_stop":
                state.message_stopped = True

        if isinstance(state, NativeSseBlockPolicyState):
            return transform_native_sse_block_event(
                event, state, thinking_enabled=thinking_enabled
            )
        return event

    def _format_error_message(self, base_message: str, request_id: str | None) -> str:
        """Keep OpenCode's existing request-id suffix format."""
        return append_request_id(base_message, request_id)

    def _emit_error_events(
        self,
        *,
        request: Any,
        input_tokens: int,
        error_message: str,
        sent_any_event: bool,
    ) -> Iterator[str]:
        """Emit the Anthropic SSE error shape expected by Claude clients."""
        yield from iter_provider_stream_error_sse_events(
            request=request,
            input_tokens=input_tokens,
            error_message=error_message,
            sent_any_event=sent_any_event,
            log_raw_sse_events=self._config.log_raw_sse_events,
        )