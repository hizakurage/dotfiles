# keychain
which keychain > /dev/null
if [ $? -eq 0 ]; then
    eval `keychain --agents ssh --eval ~/.ssh/id_rsa`
fi
