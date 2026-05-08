Wrote the report to [codex-image-gen.md](/home/fao/CXMem/notes/research/codex-image-gen.md).

Key verified points included:
- Latest real API model ID is `gpt-image-2`, not `gpt-image-2.0`.
- `gpt-image-2` was released April 21, 2026.
- Codex CLI 0.128.0 does not expose a direct built-in image generation command/MCP in this install.
- Recommended Codex path is `codex exec` dispatching a helper script or `curl`.
- `codex exec` auth should use cached Codex login or `CODEX_API_KEY`; image API calls use `OPENAI_API_KEY`.

I did not call the OpenAI API.