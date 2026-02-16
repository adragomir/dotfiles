# Remote RPC Extension

Exposes the pi coding agent RPC interface over a TCP socket, allowing remote control while running in interactive mode.

## Usage

```bash
# Start pi with the extension (default port 9999)
pi -e ./examples/extensions/remote-rpc

# Or specify a custom port
pi -e ./examples/extensions/remote-rpc --rpc-port 8080
```

## Protocol

The protocol is JSON lines over TCP, identical to pi's built-in RPC mode:

- **Commands**: JSON objects with `type` field, optional `id` for correlation
- **Responses**: JSON objects with `type: "response"`, `command`, `success`, and optional `data`/`error`
- **Events**: Agent events streamed as they occur

## Example Client (netcat)

```bash
# Connect to the RPC server
nc localhost 9999

# Send a prompt
{"type":"prompt","message":"Hello, what can you do?"}

# Get current state
{"type":"get_state"}

# Abort current operation
{"type":"abort"}
```

## Example Client (Node.js)

```javascript
const net = require('net');

const client = net.createConnection({ port: 9999 }, () => {
  // Send a prompt
  client.write(JSON.stringify({ type: 'prompt', message: 'Hello!' }) + '\n');
});

client.on('data', (data) => {
  // Each line is a JSON response or event
  data.toString().split('\n').filter(Boolean).forEach(line => {
    console.log(JSON.parse(line));
  });
});
```

## Supported Commands

| Command | Description |
|---------|-------------|
| `prompt` | Send a message to the agent |
| `steer` | Queue a steering message (interrupts mid-run) |
| `follow_up` | Queue a follow-up message (waits for completion) |
| `abort` | Abort current operation |
| `new_session` | Start a new session |
| `get_state` | Get current session state |
| `set_model` | Set model by provider and ID |
| `get_available_models` | List available models |
| `set_thinking_level` | Set thinking level (off/low/medium/high) |
| `compact` | Trigger context compaction |
| `get_messages` | Get all messages in session |
| `fork` | Fork from a specific entry |
| `set_session_name` | Set session display name |

## Unsupported Commands

These commands are not available via the extension API:

- `cycle_model` - Use `get_available_models` + `set_model` instead
- `cycle_thinking_level` - Use `set_thinking_level` directly
- `set_steering_mode`, `set_follow_up_mode`
- `set_auto_compaction`, `set_auto_retry`, `abort_retry`
- `bash`, `abort_bash`
- `get_session_stats`, `export_html`
- `switch_session`, `get_fork_messages`, `get_last_assistant_text`
- `get_commands`

## Events

The extension broadcasts these events to connected clients:

- `agent_start`, `agent_end`
- `turn_start`, `turn_end`
- `tool_call`, `tool_result`
- `model_select`
- `session_switch`, `session_fork`, `session_compact`

## Slash Commands

| Command | Description |
|---------|-------------|
| `/rpc-status` | Show server status and connection state |

## Notes

- Only one client connection at a time (new connections replace existing)
- Server binds to `0.0.0.0` (all interfaces)
- No authentication - use firewall rules for security
- TUI remains fully functional while RPC is active
