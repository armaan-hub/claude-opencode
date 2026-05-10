"""OpenCode provider - Anthropic-compatible native transport."""

from providers.defaults import OPENCODE_DEFAULT_BASE

from .client import OpenCodeProvider

__all__ = ["OPENCODE_DEFAULT_BASE", "OpenCodeProvider"]