# Particl Private Coldstaking

This script allows you to anonymize automatically your coldstaking rewards on your node and to redirect them automatically to the balance of your choice to your wallet. Receive your rewards in any of the three PART coin privacy states:

- Public
- Blind (Confidential Transactions)
- Anonymous (RingCT) `recommended`

> **If you already have a coldstaking node installed**, this script will transform it into a private coldstaking node. **If you don't have a coldstaking node installed yet**, this script will create it.

**Notes**

- The anonymization cycles vary from 1 to 32767 seconds.
- The amounts in each anonymization cycle vary from `<your coldstaking balance> × 0.00007 × 1` to `1.5`
- The amounts in each transfer cycle vary from `<your coldstaking balance> × 0.00006 × 1` to `1.5`

## Download

Download directly via `git`:

    git clone https://github.com/xe-nonymous/particl-private-coldstaking.git

## Install/Reinstall

    bash privatecoldstaking.sh

## Uninstall

    bash uninstall.sh

## Updating

    bash update.sh

## Check active scripts & balance

    bash verify.sh

## Debug

    bash log.sh
