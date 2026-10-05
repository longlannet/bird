# Bird on Linux servers: Node global bin path and auth

Session-derived troubleshooting notes for installing `bird` on a Linux/VPS host.

## Correct package

The npm package is:

```bash
npm install -g @steipete/bird
```

`@aspect-build/bird` is not the Bird X/Twitter CLI package and returns npm `E404`.

## If install succeeds but `bird` is not found

On servers with panel-managed Node.js (for example Baota/BT Node under `/www/server/nodejs/vXX.YY.ZZ`), npm may install the global binary under that Node prefix, but the prefix's `bin` directory may not be in the shell `PATH`.

Diagnose:

```bash
npm prefix -g
npm root -g
npm config get prefix
npm config get bin-links
npm list -g --depth=0 | grep bird || true
ls -l "$(npm prefix -g)/bin" | grep bird || true
ls -l "$(npm root -g)/@steipete/bird/dist/cli.js"
```

Fix by adding the reported prefix bin to PATH, e.g.:

```bash
echo 'export PATH="/www/server/nodejs/v24.18.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
which bird
bird --version
```

Or create stable symlinks when PATH persistence is undesirable:

```bash
chmod +x "$(npm root -g)/@steipete/bird/dist/cli.js"
ln -sf "$(npm prefix -g)/bin/bird" /usr/local/bin/bird
hash -r
bird --version
```

If `bird` then fails with `env: node: No such file or directory`, also expose the same Node prefix's `node` binary via PATH or symlink.

## Auth check on headless servers

`bird check` may show:

```text
auth_token: not found
ct0: not found
```

This is expected on headless servers without logged-in Safari/Chrome/Firefox profiles. Bird needs X/Twitter web cookies via one of:

- browser cookie extraction on a machine with a logged-in browser profile;
- `AUTH_TOKEN` and `CT0` environment variables;
- `--auth-token` and `--ct0` flags;
- `~/.config/bird/config.json5` with appropriate fields.

Treat `auth_token` and `ct0` as account-login secrets. Do not paste them into chat or commit them to a repo. Prefer a local config file with mode `0600`.
