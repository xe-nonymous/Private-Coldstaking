neutre='\e[0;m'
gr='\e[1;32m'
cy='\e[0;36m'
bl='\e[1;36m'

git pull
cd
cd partyman
clear
git pull
clear
yes | ./partyman update
echo ""
read -p "Press [Enter] key to continue..."
clear
./partyman status
read -p "Press [Enter] key to continue..."
clear
./partyman stakingnode stats
read -p "Press [Enter] key to continue..."
clear
cd
cd particlcore
echo -e "${bl}NODE BALANCES${neutre}"
echo ""
balances=$(./particl-cli getwalletinfo | sed -n '4,/tx/p' | sed "11d" | sed 's/"//' | sed 's/"//' |sed 's/,//' | cut -c3- | rev | cut -c6- | rev)
echo -e "${bl}$balances${neutre}"
echo ""
echo ""
echo "${bl}ACTIVE SCRIPTS${neutre}"
echo ""
ps -ef | grep bash | grep parttoanon | cut -c49-
echo ""
ps -ef | grep bash | grep anontopart | cut -c49-
echo ""
ps -ef | grep bash | grep anontoblind | cut -c49-
echo ""
