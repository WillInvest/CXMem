# Programmatic OpenAI Image Generation from Codex CLI

Research date: 2026-05-06

## 1. **Model landscape (verified 2026-05)**

OpenAI's current API image-generation family is GPT Image. The real latest API model ID is `gpt-image-2`, released April 21, 2026. It is the current state-of-the-art image generation/editing model and supports flexible image sizes, high-fidelity image inputs, token-based image pricing, and Batch API support.

There is no verified API model ID named `gpt-image-2.0`. Hao's "gpt image 2.0" maps to the product/system-card naming "ChatGPT Images 2.0" and to the API model ID `gpt-image-2`, not `gpt-image-2.0`.

Current lineup:

| Model ID | Status | Release / snapshot | What it supersedes | Notes |
|---|---:|---:|---|---|
| `gpt-image-2` | Latest | Released 2026-04-21; snapshot `gpt-image-2-2026-04-21` | Supersedes `gpt-image-1.5` for best quality/capability | Fast, high-quality generation and editing; flexible image sizes; high-fidelity inputs. |
| `gpt-image-1.5` | Previous | Released 2025-12-16; snapshot `gpt-image-1.5-2025-12-16` | Superseded `gpt-image-1` | Stronger prompt adherence than `gpt-image-1`; still supported. |
| `gpt-image-1-mini` | Cost-efficient | Released 2025-10-06 | Lower-cost alternative to GPT Image 1 family | Cheapest current GPT Image option. |
| `gpt-image-1` | Deprecated / previous | Original GPT Image API model | Superseded by `gpt-image-1.5`, then `gpt-image-2` | Model page marks it deprecated. |
| `chatgpt-image-latest` | ChatGPT image alias | Released 2025-12-16 with GPT Image 1.5 | Alias for model used in ChatGPT Images | Useful only if you deliberately want ChatGPT-aligned behavior; docs emphasize API model IDs above. |
| `dall-e-2`, `dall-e-3` | Deprecated legacy | Deprecation date in docs: support ends 2026-05-12 | Superseded by GPT Image models | `dall-e-2` is still the only variation endpoint model. |

Docs caveat: some older OpenAI image guide/API reference pages and snippets still mention only `gpt-image-1.5`, `gpt-image-1`, and `gpt-image-1-mini`, or say GPT Image 1.5 is latest. The model page, pricing page, and 2026-04-21 changelog confirm `gpt-image-2` is current.

## 2. **Capabilities matrix**

| Capability | `gpt-image-2` | `gpt-image-1.5` | `gpt-image-1-mini` | `gpt-image-1` | DALL-E legacy |
|---|---|---|---|---|---|
| Generate endpoint | `/v1/images/generations` | Same | Same | Same | Same |
| Edit/inpaint endpoint | `/v1/images/edits` | Same | Same | Same | `dall-e-2` edits; `dall-e-3` generations only |
| Variation endpoint | No | No | No | No | `dall-e-2` only |
| Response format | GPT Image models return `b64_json` by default; `url` unsupported | Same | Same | Same | `url` default; `b64_json` optional |
| Output formats | `png`, `jpeg`, `webp` | Same | Same | Same | Legacy behavior differs; use GPT Image unless variation required |
| Transparency / alpha | `background=transparent`, only with `png` or `webp` | Same | Same | Same | Not a GPT Image-style feature |
| Prompt max length | 32,000 chars for GPT Image models | Same | Same | Same | `dall-e-2`: 1,000; `dall-e-3`: 4,000 |
| Images per generation request | `n` 1-10 per API reference; verify current SDK behavior for `gpt-image-2` | Same documented range | Same documented range | Same documented range | `dall-e-3`: only `n=1` |
| Edit input limits | Up to 16 images; each GPT Image input `png`, `webp`, or `jpg`, <50 MB | Same | Same | Same | `dall-e-2`: one square PNG <4 MB |
| Input fidelity | Always high; `input_fidelity` cannot be changed | Supports fidelity control; docs note first 5 input images get higher preservation | Supports high fidelity; first image best preserved | Supports high fidelity; first image best preserved | Legacy |
| Sizes | Flexible sizes; thousands of valid resolutions; examples include `1024x1024`, `1024x1536`, `1536x1024` | `1024x1024`, `1024x1536`, `1536x1024`, `auto` | Same | Same | Legacy sizes differ |
| Quality tiers | `low`, `medium`, `high`, `auto` | Same | Same | Same | Legacy-specific |
| Streaming partial images | Image API and Responses API support partial images; model pages say model "Streaming: Not supported", so treat streaming as endpoint/tool streaming, not model feature | Same caveat | Same caveat | Same caveat | Not primary path |
| Content policy | Prompts and generated images filtered; `moderation=auto` or `low` for GPT Image models | Same | Same | Same | Filtered |
| Latency | Docs: complex prompts may take up to 2 minutes | Same | Same | Same | Varies |

Pricing shown below is output image cost for common sizes, excluding input text tokens and edit input image tokens. GPT Image models bill by tokens; total cost is input text + input images if editing + image output tokens.

| Model | Quality | 1024x1024 | 1024x1536 | 1536x1024 |
|---|---:|---:|---:|---:|
| `gpt-image-2` | low | $0.006 | $0.005 | $0.005 |
| `gpt-image-2` | medium | $0.053 | $0.041 | $0.041 |
| `gpt-image-2` | high | $0.211 | $0.165 | $0.165 |
| `gpt-image-1.5` | low | $0.009 | $0.013 | $0.013 |
| `gpt-image-1.5` | medium | $0.034 | $0.050 | $0.050 |
| `gpt-image-1.5` | high | $0.133 | $0.200 | $0.200 |
| `gpt-image-1` | low | $0.011 | $0.016 | $0.016 |
| `gpt-image-1` | medium | $0.042 | $0.063 | $0.063 |
| `gpt-image-1` | high | $0.167 | $0.250 | $0.250 |
| `gpt-image-1-mini` | low | $0.005 | $0.006 | $0.006 |
| `gpt-image-1-mini` | medium | $0.011 | $0.015 | $0.015 |
| `gpt-image-1-mini` | high | $0.036 | $0.052 | $0.052 |

Token prices per 1M tokens:

| Model | Text input | Text cached input | Text output | Image input | Image cached input | Image output |
|---|---:|---:|---:|---:|---:|---:|
| `gpt-image-2` | $5.00 | $1.25 | n/a | $8.00 | $2.00 | $30.00 |
| `gpt-image-1.5` | $5.00 | $1.25 | $10.00 | $8.00 | $2.00 | $32.00 |
| `gpt-image-1-mini` | $2.00 | $0.20 | n/a | $2.50 | $0.25 | $8.00 |
| `gpt-image-1` | $5.00 | $1.25 | n/a | $10.00 | $2.50 | $40.00 |

## 3. **API invocation — raw HTTP**

Minimal generation request, returning base64 image data and saving it locally:

```bash
prompt='A crisp product photo of a matte black mechanical keyboard on a white desk'

jq -n \
  --arg model "gpt-image-2" \
  --arg prompt "$prompt" \
  '{
    model: $model,
    prompt: $prompt,
    size: "1024x1024",
    quality: "medium",
    output_format: "png"
  }' \
| curl -sS -D /tmp/openai-img.headers \
    -X POST "https://api.openai.com/v1/images/generations" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    --data-binary @- \
| tee /tmp/openai-img.response.json \
| jq -r '.data[0].b64_json' \
| base64 --decode > ./image.png
```

Request JSON shape:

```json
{
  "model": "gpt-image-2",
  "prompt": "A crisp product photo of a matte black mechanical keyboard on a white desk",
  "size": "1024x1024",
  "quality": "medium",
  "n": 1,
  "output_format": "png",
  "background": "opaque",
  "moderation": "auto"
}
```

For GPT Image models, expect `data[0].b64_json`; `data[0].url` is unsupported. For DALL-E legacy models, `url` may be returned. A defensive decoder:

```bash
if jq -e '.data[0].b64_json' response.json >/dev/null; then
  jq -r '.data[0].b64_json' response.json | base64 --decode > image.png
elif jq -e '.data[0].url' response.json >/dev/null; then
  curl -L "$(jq -r '.data[0].url' response.json)" -o image.png
else
  jq . response.json >&2
  exit 1
fi
```

Transparent PNG:

```json
{
  "model": "gpt-image-2",
  "prompt": "A flat icon of a fountain pen, transparent background",
  "size": "1024x1024",
  "quality": "high",
  "output_format": "png",
  "background": "transparent"
}
```

Common error modes:

```json
{
  "error": {
    "message": "Rate limit reached for images per minute.",
    "type": "rate_limit_error",
    "param": null,
    "code": "rate_limit_exceeded"
  }
}
```

Handle with exponential backoff using `Retry-After`, `x-ratelimit-reset-requests`, or a bounded sleep. Avoid fan-out above the account's IPM limit.

```json
{
  "error": {
    "message": "Your request was rejected as a result of our safety system.",
    "type": "invalid_request_error",
    "param": "prompt",
    "code": "content_policy_violation"
  }
}
```

Handle by recording the refusal, returning a clear message to the user, and optionally asking for a revised prompt. Do not blindly retry unchanged prompts after content-policy refusals.

## 4. **API invocation — OpenAI Python/Node SDKs**

Python one-shot:

```python
#!/usr/bin/env python3
import base64
from openai import OpenAI

client = OpenAI()  # reads OPENAI_API_KEY

result = client.images.generate(
    model="gpt-image-2",
    prompt="A crisp product photo of a matte black mechanical keyboard on a white desk",
    size="1024x1024",
    quality="medium",
    output_format="png",
    n=1,
)

with open("image.png", "wb") as f:
    f.write(base64.b64decode(result.data[0].b64_json))
```

Node one-shot:

```javascript
#!/usr/bin/env node
import fs from "node:fs";
import OpenAI from "openai";

const client = new OpenAI(); // reads OPENAI_API_KEY

const result = await client.images.generate({
  model: "gpt-image-2",
  prompt: "A crisp product photo of a matte black mechanical keyboard on a white desk",
  size: "1024x1024",
  quality: "medium",
  output_format: "png",
  n: 1,
});

fs.writeFileSync("image.png", Buffer.from(result.data[0].b64_json, "base64"));
```

Responses API path, useful for multi-turn prompting but less direct for `/img`:

```python
import base64
from openai import OpenAI

client = OpenAI()
response = client.responses.create(
    model="gpt-5.5",
    input="Generate an image of a matte black mechanical keyboard on a white desk",
    tools=[{"type": "image_generation", "quality": "medium"}],
    tool_choice={"type": "image_generation"},
)

images = [o.result for o in response.output if o.type == "image_generation_call"]
with open("image.png", "wb") as f:
    f.write(base64.b64decode(images[0]))
```

For a simple `/img <prompt>` skill, prefer the Images API. It is simpler, exposes image-specific parameters directly, and avoids an extra mainline model step.

## 5. **Codex CLI integration paths**

### Built-in image generation in Codex CLI 0.128.0

I found no `codex` subcommand that directly generates images, and `codex mcp list` reports no configured MCP servers on this machine. `codex exec --help` exposes image inputs via `--image`, but not an image-output generation command.

OpenAI's API docs describe an `image_generation` hosted tool in the Responses API. That is an API tool, not a `codex exec` command-line image generator. In Codex CLI 0.128.0, the practical path is to let the Codex agent run `curl` or a helper script that calls `/v1/images/generations`.

### Recommended pattern

| Pattern | Recommendation | Why |
|---|---|---|
| `curl` directly inside `codex exec` | Good for minimal proof-of-concept | No dependencies except `curl`, `jq`, `base64`; more shell quoting risk. |
| Python helper invoked by Codex | Best default | Cleaner error handling, metadata capture, retries, path handling; SDK reads `OPENAI_API_KEY`. |
| Node helper invoked by Codex | Good if downstream skill is JS-heavy | Same benefits as Python, but more npm dependency surface. |
| Responses API image tool inside Codex | Use only for conversational/multi-turn image workflows | More moving parts and cost; not needed for one-shot `/img`. |
| Codex built-in/MCP image tool | Not available by default in this verified CLI install | Could be added later via MCP/plugin, but do not assume it. |

### `codex exec` invocation from an orchestrator

Use a writable output directory and network access. In current local help, available sandbox modes are `read-only`, `workspace-write`, and `danger-full-access`; official docs also describe explicit sandbox selection for automation.

Conservative version if output stays under the workspace and network is allowed by the environment/config:

```bash
mkdir -p ./artifacts/img/2026-05-06/run-001

CODEX_API_KEY="${CODEX_API_KEY:-$OPENAI_API_KEY}" \
codex exec \
  --cd /home/fao/CXMem \
  --sandbox workspace-write \
  --ask-for-approval never \
  --output-last-message ./artifacts/img/2026-05-06/run-001/codex-final.md \
  'Generate one image using ./bin/img-gen.sh or curl. Prompt: "A crisp product photo of a matte black mechanical keyboard on a white desk". Save output under ./artifacts/img/2026-05-06/run-001 and report file paths only.'
```

If the parent process is already externally sandboxed and you need guaranteed network/filesystem access:

```bash
CODEX_API_KEY="${CODEX_API_KEY:-$OPENAI_API_KEY}" \
codex exec \
  --cd /home/fao/CXMem \
  --sandbox danger-full-access \
  --ask-for-approval never \
  --output-last-message ./artifacts/img/2026-05-06/run-001/codex-final.md \
  'Generate one image ...'
```

For machine-readable orchestration, add `--json` and parse JSONL events, or use `--output-schema` for a strict final result. `--output-last-message` writes the final message to a file and still prints it to stdout.

### Auth behavior

There are two separate auth concerns:

1. The helper script/curl that calls the Images API should use `OPENAI_API_KEY` in the standard API way:

```bash
Authorization: Bearer $OPENAI_API_KEY
```

2. `codex exec` itself uses Codex CLI auth. Official Codex docs say `codex exec` reuses saved CLI authentication by default, and for CI/programmatic one-shot runs `CODEX_API_KEY` is supported only in `codex exec`:

```bash
CODEX_API_KEY="$OPENAI_API_KEY" codex exec --json "triage open bug reports"
```

Local verification on this machine:

```text
$ codex --version
codex-cli 0.128.0

$ codex login status
Logged in using ChatGPT

$ codex login --help
--with-api-key  Read the API key from stdin
```

So, do not assume `codex exec` itself reads `OPENAI_API_KEY` directly. Use one of these:

```bash
# One-shot API-key auth for the Codex agent:
CODEX_API_KEY="$OPENAI_API_KEY" codex exec ...

# Or cache API-key auth in Codex:
printenv OPENAI_API_KEY | codex login --with-api-key
codex exec ...

# Or use existing ChatGPT login:
codex login
codex exec ...
```

Inside the agent-run shell, ensure `OPENAI_API_KEY` reaches subprocesses. Codex has a `shell_environment_policy`; secrets may be filtered unless explicitly passed or configured. For image generation, the cleanest pattern is to have the parent invoke:

```bash
OPENAI_API_KEY="$OPENAI_API_KEY" CODEX_API_KEY="$OPENAI_API_KEY" codex exec ...
```

If a restrictive Codex config blocks secret inheritance, add a scoped config override only for this run:

```bash
codex exec \
  -c 'shell_environment_policy.inherit="all"' \
  ...
```

Use that carefully because it can expose more env vars to the agent's shell commands.

## 6. **Reference helper script**

Copy-paste as `bin/img-gen.sh`. This uses only `bash`, `curl`, `jq`, and `base64`; it does not require the Python or Node SDK.

```bash
#!/usr/bin/env bash
set -euo pipefail

model="gpt-image-2"
size="1024x1024"
quality="medium"
n="1"
format="png"
background="auto"
moderation="auto"
prompt=""
out=""

usage() {
  cat >&2 <<'USAGE'
Usage:
  img-gen.sh --prompt PROMPT --out OUT [--size SIZE] [--quality low|medium|high|auto] [--n N]

Options:
  --prompt       Text prompt. Required.
  --out          Output file for n=1, or output directory/prefix for n>1. Required.
  --size         Default: 1024x1024. For gpt-image-2, additional valid sizes exist.
  --quality      Default: medium.
  --n            Default: 1. Documented range: 1-10.
  --model        Default: gpt-image-2.
  --format       png|jpeg|webp. Default: png.
  --background   auto|opaque|transparent. Default: auto.
  --moderation   auto|low. Default: auto.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prompt) prompt="${2:-}"; shift 2 ;;
    --out) out="${2:-}"; shift 2 ;;
    --size) size="${2:-}"; shift 2 ;;
    --quality) quality="${2:-}"; shift 2 ;;
    --n) n="${2:-}"; shift 2 ;;
    --model) model="${2:-}"; shift 2 ;;
    --format) format="${2:-}"; shift 2 ;;
    --background) background="${2:-}"; shift 2 ;;
    --moderation) moderation="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$prompt" || -z "$out" ]]; then
  usage
  exit 2
fi

if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "OPENAI_API_KEY is not set" >&2
  exit 2
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

request="$tmpdir/request.json"
response="$tmpdir/response.json"
headers="$tmpdir/headers.txt"

jq -n \
  --arg model "$model" \
  --arg prompt "$prompt" \
  --arg size "$size" \
  --arg quality "$quality" \
  --arg format "$format" \
  --arg background "$background" \
  --arg moderation "$moderation" \
  --argjson n "$n" \
  '{
    model: $model,
    prompt: $prompt,
    size: $size,
    quality: $quality,
    n: $n,
    output_format: $format,
    background: $background,
    moderation: $moderation
  }' > "$request"

http_code="$(
  curl -sS \
    -w '%{http_code}' \
    -D "$headers" \
    -o "$response" \
    -X POST "https://api.openai.com/v1/images/generations" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    --data-binary @"$request"
)"

if [[ "$http_code" != 2* ]]; then
  echo "OpenAI image request failed: HTTP $http_code" >&2
  jq -r '.error | "type=\(.type // "unknown") code=\(.code // "unknown") message=\(.message // "no message")"' "$response" >&2 || cat "$response" >&2
  echo "x-request-id: $(grep -i '^x-request-id:' "$headers" | awk '{print $2}' | tr -d '\r')" >&2
  exit 1
fi

count="$(jq '.data | length' "$response")"
mkdir -p "$(dirname "$out")"

if [[ "$count" -eq 1 && "$n" -eq 1 ]]; then
  jq -r '.data[0].b64_json' "$response" | base64 --decode > "$out"
  meta="${out%.*}.json"
  jq --arg output "$out" --arg request_id "$(grep -i '^x-request-id:' "$headers" | awk '{print $2}' | tr -d '\r')" \
    '{created, background, output_format, quality, size, usage, output: $output, request_id: $request_id}' \
    "$response" > "$meta"
  printf '%s\n' "$out"
else
  mkdir -p "$out"
  for i in $(seq 0 $((count - 1))); do
    file="$out/image-$((i + 1)).$format"
    jq -r ".data[$i].b64_json" "$response" | base64 --decode > "$file"
    printf '%s\n' "$file"
  done
  jq --arg output_dir "$out" --arg request_id "$(grep -i '^x-request-id:' "$headers" | awk '{print $2}' | tr -d '\r')" \
    '{created, background, output_format, quality, size, usage, output_dir: $output_dir, request_id: $request_id}' \
    "$response" > "$out/metadata.json"
fi
```

Example:

```bash
bin/img-gen.sh \
  --prompt "A crisp product photo of a matte black mechanical keyboard on a white desk" \
  --out ./artifacts/img/2026-05-06/run-001/image.png \
  --size 1024x1024 \
  --quality medium \
  --n 1
```

## 7. **Skill-design implications for `/img`**

Single-agent path:

```bash
run_id="$(date -u +%Y%m%dT%H%M%SZ)-$(openssl rand -hex 3)"
out_dir="/home/fao/CXMem/artifacts/img/$run_id"
mkdir -p "$out_dir"

OPENAI_API_KEY="$OPENAI_API_KEY" CODEX_API_KEY="${CODEX_API_KEY:-$OPENAI_API_KEY}" \
codex exec \
  --cd /home/fao/CXMem \
  --sandbox workspace-write \
  --ask-for-approval never \
  --output-last-message "$out_dir/codex-final.md" \
  "Use bin/img-gen.sh to generate one image for this prompt: $PROMPT. Save it as $out_dir/image.png. Write metadata as $out_dir/metadata.json. Final answer must be JSON with output_path, metadata_path, model, size, quality."
```

Multi-agent path:

```bash
for i in 1 2 3 4; do
  out_dir="/home/fao/CXMem/artifacts/img/$run_id/variant-$i"
  mkdir -p "$out_dir"
  (
    style_hint="$(jq -r ".[$((i-1))]" styles.json)"
    OPENAI_API_KEY="$OPENAI_API_KEY" CODEX_API_KEY="${CODEX_API_KEY:-$OPENAI_API_KEY}" \
    codex exec \
      --cd /home/fao/CXMem \
      --sandbox workspace-write \
      --ask-for-approval never \
      --output-last-message "$out_dir/codex-final.md" \
      "Generate one image with style hint '$style_hint'. Prompt: $PROMPT. Save image and metadata under $out_dir."
  ) &
done
wait
```

Suggested output convention:

```text
artifacts/img/
  20260506T231500Z-a1b2c3/
    manifest.json
    prompt.txt
    variant-1/
      image.png
      metadata.json
      codex-final.md
      response.json
    variant-2/
      image.png
      metadata.json
      codex-final.md
```

Record metadata beside every image:

```json
{
  "prompt_original": "...",
  "prompt_effective": "...",
  "model": "gpt-image-2",
  "size": "1024x1024",
  "quality": "medium",
  "n": 1,
  "output_format": "png",
  "background": "auto",
  "moderation": "auto",
  "created_at": "2026-05-06T23:15:00Z",
  "request_id": "req_...",
  "usage": {
    "input_tokens": 0,
    "output_tokens": 0,
    "total_tokens": 0
  },
  "estimated_cost_usd": 0.053,
  "codex": {
    "version": "0.128.0",
    "sandbox": "workspace-write",
    "auth_mode": "CODEX_API_KEY or cached ChatGPT"
  },
  "source_files": []
}
```

Failure handling:

| Failure | Handling |
|---|---|
| Rate limit / 429 | Retry with exponential backoff and jitter; honor `Retry-After` or rate-limit reset headers; cap retries at 3-5. |
| Transient 5xx / network | Retry with backoff; preserve failed response and request ID. |
| Content policy refusal | Do not retry unchanged; record refusal and return a prompt-revision request. |
| Missing `OPENAI_API_KEY` | Fail before dispatching Codex agents. |
| Codex auth missing | Use `CODEX_API_KEY="$OPENAI_API_KEY"` for exec, or run `printenv OPENAI_API_KEY \| codex login --with-api-key`. |
| Partial multi-agent failure | Keep successful variants; write a top-level manifest listing failed variants and reasons. |

## 8. **Open questions / risks**

1. `gpt-image-2` supports flexible sizes, but the docs do not expose a complete machine-readable list of valid width/height constraints in the pages consulted. The skill should validate common sizes locally and pass through custom sizes only after empirical testing.
2. The API reference enum page consulted still omits `gpt-image-2` in one model enum section while the model page, changelog, pricing, and guide confirm it. Treat this as stale reference generation.
3. Streaming docs and model pages are semantically inconsistent: guides show endpoint/tool partial-image streaming, while model pages say model streaming is not supported. For `/img`, avoid streaming unless user experience requires it.
4. `n=1..10` is documented for image generation, but parallel single-image requests are often easier to isolate and retry than one `n>1` request. Test account-specific IPM and latency before choosing the default.
5. `CODEX_API_KEY` is documented as `codex exec`-only. `OPENAI_API_KEY` remains the standard SDK/curl variable. The orchestrator should set both when launching Codex workers.
6. Codex shell environment filtering can suppress secrets. A downstream skill must test whether `OPENAI_API_KEY` reaches the agent's shell under Hao's actual `~/.codex/config.toml`.
7. Costs can differ from the table for `gpt-image-2` custom sizes. Use returned `usage` plus pricing tables for post-hoc accounting.

## 9. **Source list**

| URL | What it confirmed |
|---|---|
| https://developers.openai.com/api/docs/changelog | `gpt-image-2` released 2026-04-21; `gpt-image-1.5` released 2025-12-16; `gpt-image-1-mini` released 2025-10-06; Batch/API updates. |
| https://developers.openai.com/api/docs/models/gpt-image-2 | Current `gpt-image-2` model page, snapshot `gpt-image-2-2026-04-21`, endpoints, rate limits, state-of-the-art description. |
| https://developers.openai.com/api/docs/guides/image-generation | Generation/edit examples, GPT Image parameters, moderation, transparency, latency, flexible sizes, pricing calculator table. |
| https://developers.openai.com/api/docs/pricing | Token prices for `gpt-image-2`, `gpt-image-1.5`, and `gpt-image-1-mini`; Batch discount. |
| https://developers.openai.com/api/docs/models/gpt-image-1.5 | `gpt-image-1.5` pricing, snapshot, endpoints, previous-model status. |
| https://developers.openai.com/api/docs/models/gpt-image-1-mini | `gpt-image-1-mini` cost-efficient status, pricing, endpoints. |
| https://developers.openai.com/api/docs/models/gpt-image-1 | `gpt-image-1` previous/deprecated status, pricing, endpoints. |
| https://developers.openai.com/api/reference/resources/images | Image API response fields, b64 vs url behavior, prompt length, n range, edit limits; noted stale enum inconsistency around `gpt-image-2`. |
| https://openai.com/index/new-chatgpt-images-is-here/ | Public release context for ChatGPT Images / GPT Image 1.5 and product naming. |
| https://deploymentsafety.openai.com/chatgpt-images-2-0/chatgpt-images-2-0.pdf | Confirms "ChatGPT Images 2.0" product/system-card naming, distinct from the API model ID `gpt-image-2`. |
| https://developers.openai.com/codex/auth | Codex auth methods, ChatGPT vs API key, local credential cache, headless/device auth, credential storage. |
| https://developers.openai.com/codex/noninteractive | `codex exec` automation behavior, sandbox guidance, `--json`, `--output-last-message`, and `CODEX_API_KEY` for CI/programmatic runs. |
| https://developers.openai.com/codex/config-basic | Codex config file precedence and user/project config locations. |
| https://developers.openai.com/codex/config-advanced | Shell environment policy and sandbox/network configuration details. |
| https://developers.openai.com/codex/config-reference | MCP configuration and environment variable forwarding details. |
| https://github.com/openai/codex/blob/main/docs/authentication.md | Official repo points auth docs to developers.openai.com. |
| https://www.mintlify.com/openai/codex/cli/exec | Unofficial generated CLI reference used only as a secondary cross-check for `codex exec` flags. |

