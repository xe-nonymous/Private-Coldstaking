yel='\e[1;33m'
neutre='\e[0;m'
gr='\e[1;32m'
red='\e[0;31m'
bl='\e[1;34m'

cd

script1=$(ps -ef | grep bash | grep script1.sh | cut -c10-14)
num=$(echo $script1 | wc -w)
x=1; while [ $x -le $num ]; do kill=$(ps -ef | grep bash | grep script1.sh | cut -c10-14 | sed -n "1p") && sudo kill -9 $kill $(( x++ )); done

script2=$(ps -ef | grep bash | grep script2.sh | cut -c10-14)
num=$(echo $script2 | wc -w)
x=1; while [ $x -le $num ]; do kill=$(ps -ef | grep bash | grep script2.sh | cut -c10-14 | sed -n "1p") && sudo kill -9 $kill $(( x++ )); done

parttoanon=$(ps -ef | grep bash | grep sendparttoanon | cut -c10-14)
num=$(echo $parttoanon | wc -w)
x=1; while [ $x -le $num ]; do kill=$(ps -ef | grep bash | grep sendparttoanon | cut -c10-14 | sed -n "1p") && sudo kill -9 $kill $(( x++ )); done

anontopart=$(ps -ef | grep bash | grep anontopart | cut -c10-14)
num=$(echo $anontopart | wc -w)
x=1; while [ $x -le $num ]; do kill=$(ps -ef | grep bash | grep sendanontopart | cut -c10-14 | sed -n "1p") && sudo kill -9 $kill $(( x++ )); done

anontoblind=$(ps -ef | grep bash | grep anontoblind | cut -c10-14)
num=$(echo $anontoblind | wc -w)
x=1; while [ $x -le $num ]; do kill=$(ps -ef | grep bash | grep sendanontoblind | cut -c10-14 | sed -n "1p") && sudo kill -9 $kill $(( x++ )); done



clear

sudo apt-get update && sudo apt-get upgrade <<< y

sudo apt-get install python git unzip pv jq <<< y

cd ~ && git clone https://github.com/dasource/partyman

cd partyman/

clear

yes | ./partyman install

clear

./partyman restart now

while [ "$checkinit" != "35" ]
do
clear
./partyman stakingnode init
cd && cd particlcore 
rewardaddress=$(./particl-cli getnewaddress) 
checkinit=$(echo "$rewardaddress" | wc -c)  
cd && cd partyman
done

git pull

clear

yes | ./partyman update

clear

while [[ ! "$sendto" =~ ^(private)$ ]] && [[ ! "$sendto" =~ ^(blind)$ ]] && [[ ! "$sendto" =~ ^(public)$ ]]
do
clear
echo -e "${yel}Do you want to receive your anonymized coins on the public, blind or private balance of your wallet ? ${neutre}"
echo -e "[${gr}public${neutre}]/${bl}blind${neutre}/${red}private${neutre}]"
read sendto
done

if [ $sendto = "public" ]
then

while [ "$numcharaddress" != "35" ]
do
clear
cd && cd particlcore  
echo -e "${yel}Enter a public address generated from your Desktop/Qt/Copay wallet, this address will be the reception address for your anonymized rewards:${neutre}" && read wallet
numcharaddress=$(echo "$wallet" | wc -c)
done

./particl-cli walletsettings stakingoptions "{\"rewardaddress\":\"$rewardaddress\"}"

stealthaddressnode=$(./particl-cli getnewstealthaddress) 

csbalance=$(./particl-cli getcoldstakinginfo | grep coin_in_cold | cut -c35-44)
csbal=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)
csbalfin=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)

ratio1=0.00007
ratio2=0.00006

entro=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed);  printf("%.4f\n", rand()) }')
entro=$(printf '%.3f\n' "$(echo "$entro" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "*" "1000" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "+" "1000" | bc -l)")
entro=$(echo "$entro" | cut -d "." -f 1 | cut -d "," -f 1)

if [[ "$entro" -gt 1500 ]] ; then

        entro=$(echo "$entro" "-" "500" | bc -l)
fi

entro=$(printf '%.3f\n' "$(echo "$entro" "/" "1000" | bc -l)")


while ((csbal < 1))
do
clear
echo -e "${yel}Enter the number of coins that you want to coldstake on this node:${neutre}" && read csbal
csbal=$(echo $csbal | cut -d "." -f 1 | cut -d "," -f 1 | tr -d [a-zA-Z]| sed -n '/^[[:digit:]]*$/p' )
done

amount1=$(printf '%.3f\n' "$(echo "$csbal" "*" "$ratio1" "*" "$entro" | bc -l)")
amount2=$(printf '%.3f\n' "$(echo "$csbal" "*" "$ratio2" "*" "$entro" | bc -l)")

echo "bash -c 'while true;do ./particl-cli settxfee 0.002 && ./particl-cli sendparttoanon $stealthaddressnode $amount1; sleep $[$RANDOM+1]s; done' " > script1.sh

echo "bash -c 'while true;do ./particl-cli settxfee 0.002 && ./particl-cli sendanontopart $wallet $amount2; sleep $[$RANDOM+1]s; done'" > script2.sh

time1=$(cat script1.sh | cut -c188- | rev | cut -d "p" -f 1 | rev | cut -d ";" -f 1 | cut -c2- | cut -d "s" -f 1)
time2=$(cat script2.sh | cut -c120- | rev | cut -d "p" -f 1 | rev | cut -d ";" -f 1 | cut -c2- | cut -d "s" -f 1)

clear

echo -e "${gr}PARTICL PRIVATE COLDSTAKING V1.0 ${neutre}"
echo "PARTICL PRIVATE COLDSTAKING" > contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
if ((csbalfin < 1 ));
then
extaddress=$(./particl-cli getnewextaddress)
echo -e "${yel}This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:${neutre}"
echo "This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:" >> contractprivatecs.txt
echo ""
echo "" >> contractprivatecs.txt
echo -e "${gr}$extaddress ${neutre}"
echo "$extaddress" >> contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
fi
echo -e "${yel}Every${neutre}${gr} $time1 seconds${neutre}${yel}, the node is going to anonymize${neutre}${gr} $amount1 parts${neutre}${yel} from your available coldstaking rewards on this address: ${neutre}${gr}$rewardaddress${neutre}${yel} to the anon balance of your node.${neutre}"
echo "Every $time1 seconds, the node is going to anonymize $amount1 parts from your available coldstaking rewards on this address: $rewardaddress to the anon balance of your node." >> contractprivatecs.txt
echo ""
echo "" >> contractprivatecs.txt
echo ""
echo -e "${yel}Every${neutre}${gr} $time2 seconds${neutre}${yel}, the node is going to send you back${neutre}${gr} $amount2 parts${neutre}${yel} from the available anon balance of your node to this public address: ${neutre}"
echo ""
echo -e "${gr}$wallet ${neutre}"
echo "" >> contractprivatecs.txt
echo "Every $time2 seconds, the node is going to send you back $amount2 parts from the available anon balance of your node to this public address:" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
echo "$wallet" >> contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
echo -e "${yel}Press${neutre} ${gr}ENTER${neutre} ${yel}to finalize this process${neutre}"
echo ""

mv contractprivatecs.txt ../Private-Coldstaking/contract.txt

nohup bash script1.sh & nohup bash script2.sh </dev/null >nohup.out 2>nohup.err &

fi


if [ $sendto = "private" ]
then

while [ "$numcharaddress" != "103" ]
do
clear
cd && cd particlcore && echo -e "${yel}Enter a private address (stealth address) generated from your Desktop/Qt wallet, this address will be the reception address for your coldstaking rewards:${neutre}" && read wallet
numcharaddress=$(echo "$wallet" | wc -c)
done

./particl-cli walletsettings stakingoptions "{\"rewardaddress\":\"$rewardaddress\"}"

csbalance=$(./particl-cli getcoldstakinginfo | grep coin_in_cold | cut -c35-44)
csbal=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)
csbalfin=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)

ratio1=0.00007

entro=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed);  printf("%.4f\n", rand()) }')
entro=$(printf '%.3f\n' "$(echo "$entro" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "*" "1000" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "+" "1000" | bc -l)")
entro=$(echo "$entro" | cut -d "." -f 1 | cut -d "," -f 1)

if [[ "$entro" -gt 1500 ]] ; then

        entro=$(echo "$entro" "-" "500" | bc -l)
fi

entro=$(printf '%.3f\n' "$(echo "$entro" "/" "1000" | bc -l)")

while ((csbal < 1))
do
clear
echo -e "${yel}Enter the number of coins that you want to coldstake on this node:${neutre}" && read csbal
csbal=$(echo $csbal | cut -d "." -f 1 | cut -d "," -f 1 | tr -d [a-zA-Z]| sed -n '/^[[:digit:]]*$/p' )
done

amount1=$(printf '%.3f\n' "$(echo "$csbal" "*" "$ratio1" "*" "$entro" | bc -l)")

echo "bash -c 'while true;do ./particl-cli settxfee 0.002 && ./particl-cli sendparttoanon $wallet $amount1; sleep $[$RANDOM+1]s; done' " > script1.sh

time1=$(cat script1.sh | cut -c188- | rev | cut -d "p" -f 1 | rev | cut -d ";" -f 1 | cut -c2- | cut -d "s" -f 1)

clear

echo -e "${gr}PARTICL PRIVATE COLDSTAKING V1.0${neutre}"
echo "PARTICL PRIVATE COLDSTAKING" > contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
if ((csbalfin < 1 ));
then
extaddress=$(./particl-cli getnewextaddress)
echo -e "${yel}This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:${neutre}"
echo "This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:" >> contractprivatecs.txt
echo ""
echo "" >> contractprivatecs.txt
echo -e "${gr}$extaddress ${neutre}"
echo "$extaddress" >> contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
fi
echo -e "${yel}Every${neutre}${gr} $time1 seconds${neutre}${yel}, the node is going to anonymize${neutre}${gr} $amount1 parts${neutre}${yel} from your available coldstaking rewards on this address: ${neutre}${gr}$rewardaddress${neutre}${yel} to the anon balance of your wallet.${neutre}" 
echo "Every $time1 seconds, the node is going to anonymize $amount1 parts from your available coldstaking rewards on this address: $rewardaddress to the anon balance of your wallet." >> contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt

mv contractprivatecs.txt ../Private-Coldstaking/contract.txt

nohup bash script1.sh </dev/null >nohup.out 2>nohup.err &

fi



if [ $sendto = "blind" ]
then

while [ "$numcharaddress" != "103" ]
do
clear
cd && cd particlcore && echo -e "${yel}Enter a private address (stealth address) generated from your Desktop/Qt wallet, this address will be the reception address for your coldstaking rewards:${neutre}" && read wallet
numcharaddress=$(echo "$wallet" | wc -c)
done

./particl-cli walletsettings stakingoptions "{\"rewardaddress\":\"$rewardaddress\"}"

stealthaddressnode=$(./particl-cli getnewstealthaddress) 

csbalance=$(./particl-cli getcoldstakinginfo | grep coin_in_cold | cut -c35-44)
csbal=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)
csbalfin=$(echo $csbalance | cut -d "." -f 1 | cut -d "," -f 1)

ratio1=0.00007
ratio2=0.00006

entro=$(awk -v seed="$RANDOM" 'BEGIN { srand(seed);  printf("%.4f\n", rand()) }')
entro=$(printf '%.3f\n' "$(echo "$entro" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "*" "1000" | bc -l)")
entro=$(printf '%.3f\n' "$(echo "$entro" "+" "1000" | bc -l)")
entro=$(echo "$entro" | cut -d "." -f 1 | cut -d "," -f 1)

if [[ "$entro" -gt 1500 ]] ; then

        entro=$(echo "$entro" "-" "500" | bc -l)
fi

entro=$(printf '%.3f\n' "$(echo "$entro" "/" "1000" | bc -l)")


while ((csbal < 1))
do
clear
echo -e "${yel}Enter the number of coins that you want to coldstake on this node:${neutre}" && read csbal
csbal=$(echo $csbal | cut -d "." -f 1 | cut -d "," -f 1 | tr -d [a-zA-Z]| sed -n '/^[[:digit:]]*$/p' )
done

amount1=$(printf '%.3f\n' "$(echo "$csbal" "*" "$ratio1" "*" "$entro" | bc -l)")
amount2=$(printf '%.3f\n' "$(echo "$csbal" "*" "$ratio2" "*" "$entro" | bc -l)")

echo "bash -c 'while true;do ./particl-cli settxfee 0.002 && ./particl-cli sendparttoanon $stealthaddressnode $amount1; sleep $[$RANDOM+1]s; done' " > script1.sh

echo "bash -c 'while true;do ./particl-cli settxfee 0.002 && ./particl-cli sendanontoblind $wallet $amount2; sleep $[$RANDOM+1]s; done'" > script2.sh

time1=$(cat script1.sh | cut -c188- | rev | cut -d "p" -f 1 | rev | cut -d ";" -f 1 | cut -c2- | cut -d "s" -f 1)
time2=$(cat script2.sh | cut -c189- | rev | cut -d "p" -f 1 | rev | cut -d ";" -f 1 | cut -c2- | cut -d "s" -f 1)

clear

echo -e "${gr}PARTICL PRIVATE COLDSTAKING V1.0 ${neutre}"
echo "PARTICL PRIVATE COLDSTAKING" > contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
if ((csbalfin < 1 ));
then
extaddress=$(./particl-cli getnewextaddress)
echo -e "${yel}This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:${neutre}"
echo "This is your coldstaking node public key, copy past it in your wallet to initialize the coldstaking smartcontract:" >> contractprivatecs.txt
echo ""
echo "" >> contractprivatecs.txt
echo -e "${gr}$extaddress ${neutre}"
echo "$extaddress" >> contractprivatecs.txt
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
fi
echo -e "${yel}Every${neutre}${gr} $time1 seconds${neutre}${yel}, the node is going to anonymize${neutre}${gr} $amount1 parts${neutre}${yel} from your available coldstaking rewards on this address: ${neutre}${gr}$rewardaddress${neutre}${yel} to the anon balance of your node.${neutre}"
echo "Every $time1 seconds, the node is going to anonymize $amount1 parts from your available coldstaking rewards on this address: $rewardaddress to the anon balance of your node." >> contractprivatecs.txt
echo ""
echo ""
echo -e "${yel}Every${neutre}${gr} $time2 seconds${neutre}${yel}, the node is going to send you back${neutre}${gr} $amount2 parts${neutre}${yel} from the available anon balance of your node to the blind balance of your wallet.${neutre}" 
echo ""
echo ""
echo "" >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
echo "Every $time2 seconds, the node is going to send you back $amount2 parts from the available anon balance of your node to the blind balance of your wallet." >> contractprivatecs.txt
echo "" >> contractprivatecs.txt
echo -e "${yel}Press${neutre} ${gr}ENTER${neutre} ${yel}to finalize this process${neutre}"
echo ""

mv contractprivatecs.txt ../Private-Coldstaking/contract.txt

nohup bash script1.sh & nohup bash script2.sh </dev/null >nohup.out 2>nohup.err &

fi
