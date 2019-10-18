#!/bin/bash

f_criar_lista(){
ITEM_SELECIONADO=$(zenity --list --text "Selecione uma das açoes a seguir" \
	--radiolist \
	--column "Marcar" \
	--column "Açao de sistema" \
	TRUE "Atualizar Pacotes" FALSE "Atualizar Sistema" FALSE "Instalar MySQL" FALSE "Escanear Sistema" FALSE Exit);

echo "Item selecionado: $ITEM_SELECIONADO";

if [ "$ITEM_SELECIONADO" = "Atualizar Pacotes" ]; then
	sudo apt-get update -y;
	echo "Pacotes atualizados com sucesso !";
	f_criar_lista
fi

if [ "$ITEM_SELECIONADO" = "Atualizar Sistema" ]; then
	sudo apt-get upgrade -y;
	echo "Sistema atualizado !";
	f_criar_lista
fi
if [ "$ITEM_SELECIONADO" = "Instalar MySQL" ]; then
	zenity --info --title="MySQL MANAGER"\
	--text="Bem vindo a instalacao do MySQL";
if zenity --question --title="MySQL MANAGER"\
	--text="Deseja instalar o MYSQL?";
	then
	ssh root@debian10
	if zenity --question --title="MySQL MANAGER"\
		--text="Deseja atualizar seus pacotes primeiro?";
		then
		(sudo apt-get update
		echo "50";sleep 2
		sudo apt-get upgrade
		echo "75";sleep 2
		echo "100";sleep 2
		)|
		zenity --progress\
		--title "Progresso do Update"\
		--text "Aguarde alguns instantes"\
		--percentage=0
	fi
	zenity --info --title="Instalacao" --text="Realizando configuracao do ambiente"
	wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
	sudo dpkg -i mysql-apt-config_0.8.13-1_all.deb
	if zenity --question --title="MySQL MANAGER"\
		--text="Deseja selecionar uma outra versao?";
		then
		sudo dpkg-reconfigure mysql-apt-config
	fi
	zenity --info --title="Instalacao" --text="A instalacao vai comecar"
	sudo apt-get install mysql-server
	else
	if zenity --question --title="MySQL MANAGER"\
	--text="Deseja desinstalar o MYSQL?";
	then
		apt-get remove --purge mysql-server mysql-client mysql-common -y
		apt-get autoremove -y
		apt-get autoclean
	zenity --info --title="MySQL MANAGER" --text="Desinstalacao completa"
	if zenity --question --title="MySQL MANAGER"\
	--text="Deseja apagar o diretorio do MYSQL?";
	then
	rm -rf /etc/mysql
	fi
	if zenity --question --title="MySQL MANAGER"\
	--text="Deseja apagar todos os arquivos MYSQL?";
	then
	find / -iname 'mysql*' -exec rm -rf {}\;
	fi
	fi
fi

	f_criar_lista
fi

if [ "$ITEM_SELECIONADO" = "Escanear Sistema" ]; then
	clear;
	echo -e "********** Informaçoes do Sistema **********\n\n\n";
	echo -e "----- BIOS: -----\n";
	sudo dmidecode -t 0,13;
	echo -e "----- Sistema -----\n";
	sudo dmidecode -t 1,12,15,23,32;
	echo -e "----- Processador -----\n";
	sudo dmidecode -t 4;
	echo -e "----- Memoria -----\n";
	sudo dmidecode -t 5,6,16,17;
	echo -e "----- Cache -----\n";
	sudo dmidecode  -t 7;
	echo -e "----- Conector e Slot -----\n";
	sudo dmidecode -t 8,9;
	echo "********** Fim das informaçoes do Sistema **********";
	f_criar_lista
fi

if [ "$?" -eq 1 ]; then
	zenity --error --text="Dialog Cancelado"
	exit 1
fi


}

#Funcao Principal
f_main(){
#for(( ; ; ))
#do
	f_criar_lista
#done
}
f_main

exit
