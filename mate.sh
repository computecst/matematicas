#!/bin/bash


##### variables globales
DIA=`date +"%d/%m/%Y"`
HORA=`date +"%H:%M"`
APACHE=`apt-get install apache2 -y >> /dev/null`
POSTGRESQL=`apt-get install postgresql postgresql-client -y >> /dev/null`
MYSQL=`apt-get install mysql-common mysql-client-5.5 mysql-server-5.5 -y`
PHP=`apt-get install php7.0 php7.0-common php7.0-dba php7.0 -y >> /dev/null`
VIRTUALENVIRONMENT="/etc/apache2/sites-available/"
NAME_VIRTUALENVIRONMENT="webapplication"
URL_WEB_APP="/var/www/html/"$NAME_VIRTUALENVIRONMENT
#echo $URL_WEB_APP
#exit
URL_CODEIGNITER="wget -O code.zip https://github.com/bcit-ci/CodeIgniter/archive/3.1.4.zip"

#DOWNLOAD_CODEIGNITER="wget -O code.zip $URL_CODEIGNITER | unzip code.zip >> /dev/null | cd CodeIgniter-3.1.4 | mv * ./../ | cd .. | rm -r CodeIgniter-3.1.4"

##### Argumentos
VERBOSE=$1


### requerimientos
ZIP=`apt-get install zip -y >> /dev/null`
$ZIP

### funciones
function config_virtual_environment {
	echo -e "<VirtualHost *:80>
        ServerName $NAME_VIRTUALENVIRONMENT".loc"
        ServerAlias "www."$NAME_VIRTUALENVIRONMENT".loc"
        ServerAdmin webmaster@localhost
        DocumentRoot $URL_WEB_APP
        ErrorLog ${URL_WEB_APP}/log/error.log
        CustomLog ${URL_WEB_APP}/log/access.log combined
</VirtualHost>
" >> $VIRTUALENVIRONMENT$NAME_VIRTUALENVIRONMENT".conf"

	# grep -c --> cuenta numero de coincidencias
	ETC_HOST=`awk '{print }' /etc/hosts | grep -c webapplication`
	echo $ETC_HOST

	if [ $ETC_HOST -le 0 ]; then
		echo -e "127.0.0.1 \t$NAME_VIRTUALENVIRONMENT.loc" >> "/etc/hosts"
	fi

	HOST="a2ensite $VIRONMENT$NAME_VIRTUALENVIRONMENT.conf"
	NEW_HOST=`service apache2 reload`
	if $HOST; then
		if $NEW_HOST; then
			echo "O.K."
		else
			echo "error"
		fi
	fi
}




# validando el numero de argumento
if [ $# -eq 1 ]; then
	# modo verboso
	if [ $VERBOSE == -v ]; then
        	#apt-get update
        	APACHE="apt-get install apache2 -y"
        	PHP="apt-get install php7.0 php7.0-common php7.0-dba php7.0"
	# argumentos no validos
	else
        	echo "argumento no valido"
	fi
fi

# instalando apache
if $APACHE; then
	echo -e "apache: True \t datetime: $DIA $HORA" >> install.log
	
	# creando entorno virtual
	if [ -d $VIRTUALENVIRONMENT ]
	then
		if [ -f $NAME_VIRTUALENVIRONMENT ]
		then
			echo "YA existe el archivo $NAME_VIRTUALENVIRONMENT en la ruta $VIRTUALENVIRONMENT, por tanto no se puede crear el entorno virtual"
		else
			if [ -d $URL_WEB_APP ]; then
				if [ -d $URL_WEB_APP"/log" ]; then
					echo "ya existe dir log en $URL_WEB_APP"
				else
					mkdir $URL_WEB_APP"/log"
				fi
			else
				mkdir $URL_WEB_APP
				mkdir $URL_WEB_APP"/log"
				cd $URL_WEB_APP
                        	#pwd
				$URL_CODEIGNITER
				unzip code.zip >> /dev/null
                        	cd "CodeIgniter-3.1.4"
                        	mv * ./../
                        	cd ..
                        	rm -r "CodeIgniter-3.1.4"
				#$OWNLOAD_CODEIGNITER
			fi
			
			# configuracion del entorno virtual
			if [ -f $VIRTUALENVIRONMENT$NAME_VIRTUALENVIRONMENT".conf" ]; then
				/usr/bin/firefox -new-window $NAME_VIRTUALENVIRONMENT".loc"
			else
				config_virtual_environment
				/usr/bin/firefox -new-window $NAME_VIRTUALENVIRONMENT".loc"
			fi
			# fin - entorno virtual
		fi
	else
		echo "No, no existe el direcotorio $VIRTUALENVIRONMENT, error para crear el entorno virtual"
		echo -e "error para crear entorno virtual $NAME_VIRTUALENVIRONMENT \t datetime: $DIA $HORA" >> install.log
	fi
else
	echo -e "apache: False \t datetime: $DIA $HORA" >> install.log
	echo "error para instalar apache, no se puede proceder" 
	exit
fi

# instalando php7
if $PHP; then
        echo -e "php7: True \t datetime: $DIA $HORA" >> install.log
else
        echo -e "php7: False \t datetime: $DIA $HORA" >> install.log
	echo "error para instalar php, no se puede proceder" 
        exit
fi

# instalando postgresql
if $POSTGRESQL; then
        echo -e "postgresql: True \t datetime: $DIA $HORA" >> install.log
else
        echo -e "postgresql: False \t datetime: $DIA $HORA" >> install.log
        echo "error para instalar postgresql, no se puede proceder" 
        exit
fi

# instalando mysql
if $MYSQL; then
        echo -e "mysql: True \t datetime: $DIA $HORA" >> install.log
else
        echo -e "mysql: False \t datetime: $DIA $HORA" >> install.log
        echo "error para instalar mysql, no se puede proceder" 
        exit
fi

