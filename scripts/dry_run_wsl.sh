#!/bin/bash
set -e

TEST_HOME=/tmp/testhome123
rm -rf "$TEST_HOME"
mkdir -p "$TEST_HOME"
printf '# test zshrc\n' > "$TEST_HOME/.zshrc"
cat > "$TEST_HOME/.gitconfig" <<'GIT'
[user]
	name = statikfintechllc
	email = ascend.gremlin@gmail.com
GIT

mkdir -p /tmp/fakebin

cat > /tmp/fakebin/sudo <<'SH'
#!/bin/sh
echo "[sudo stub] $@"
exit 0
SH

cat > /tmp/fakebin/apt-get <<'SH'
#!/bin/sh
echo "[apt-get stub] $@"
exit 0
SH

cat > /tmp/fakebin/curl <<'SH'
#!/bin/sh
# Simple stub: when called with -fsSL, output a harmless shell script
cat <<'OUT'
#!/bin/sh
echo "[fake curl install]"
OUT
SH

cat > /tmp/fakebin/chsh <<'SH'
#!/bin/sh
echo "[chsh stub] $@"
exit 0
SH

chmod +x /tmp/fakebin/*
export PATH=/tmp/fakebin:$PATH
export HOME="$TEST_HOME"

# Run the installer and capture logs
sh -x /mnt/c/Users/stati/builds/zsh.installer/master/ish.zsh.installer > /tmp/installer.log 2>&1 || true
tail -n 200 /tmp/installer.log
