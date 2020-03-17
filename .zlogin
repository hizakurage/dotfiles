# keychain
if [[ -x "${commands[keychain]}" ]]; then
    eval `keychain --agents ssh --eval ~/.ssh/id_rsa`
fi
