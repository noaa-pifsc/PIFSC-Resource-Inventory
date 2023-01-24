FROM php:8.1-apache

# installing required stuff
RUN apt-get update && apt-get install -y \
	cron \
	dos2unix \
	git \
	libaio-dev \
	libmcrypt-dev \
	libpng-dev \
	libzip-dev \
	unzip \
  && rm -rf /var/lib/apt/lists/*

# install PHP extensions
 RUN \
    docker-php-ext-install zip \
    && docker-php-ext-install gd

# xdebug, if you want to debug
# RUN pecl install xdebug \
#    && docker-php-ext-enable xdebug

# install PHP composer
RUN curl -sS https://getcomposer.org/installer | php --  --install-dir=/usr/bin --filename=composer

# apache configurations
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load

# Oracle instantclient

	# copy oracle files
	# ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /tmp/
	ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basic-linux.x64-21.1.0.0.0.zip /tmp/
	# ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /tmp/
	ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sdk-linux.x64-21.1.0.0.0.zip /tmp/
	# ADD oracle/instantclient-sqlplus-linux.x64-12.1.0.2.0.zip /tmp/
	ADD https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip /tmp/

	# unzip them
	RUN unzip /tmp/instantclient-basic-linux.x64-*.zip -d /usr/local/ \
	    && unzip /tmp/instantclient-sdk-linux.x64-*.zip -d /usr/local/

	#cleanup installation source files
	RUN rm -rf /tmp/*

	# install oci8
	RUN ln -s /usr/local/instantclient_*_1 /usr/local/instantclient \
	    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

	# configure oracle client:
		# set ORACLE_HOME value so the sqlnet.ora file is used properly
		ENV ORACLE_HOME /usr/local/instantclient
		# set TNS_ADMIN value so the sqlnet.ora file is used properly
		ENV TNS_ADMIN $ORACLE_HOME/network/admin

		# copy sqlnet.ora configuration for SQLPlus client:
		COPY ./pifsc-resource-inventory/docker/sqlnet.ora /usr/local/instantclient/network/admin/sqlnet.ora

# configure php with oci8 support
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
    && docker-php-ext-install oci8 \
    && echo /usr/local/instantclient/ > /etc/ld.so.conf.d/oracle-insantclient.conf \
    && ldconfig


		#copy the application files:
#		COPY ./pifsc-resource-inventory/RIA /var/www/html
#		COPY ./pifsc-resource-inventory/GIM /usr/src/GIM
		COPY ./php-shared-library/*.php /usr/src/php-shared-library/
		COPY ./php-shared-library/*.inc /usr/src/php-shared-library/
		COPY ./php-shared-library/css /var/www/html/php-shared-library/css
		COPY ./php-shared-library/js /var/www/html/php-shared-library/js
		COPY ./php-shared-library/img /var/www/html/php-shared-library/img

		# create the GIM directory for the backend module
		RUN mkdir /usr/src/GIM


		# allow apache user to modify files in the www directory
		RUN chown -R www-data:www-data /var/www/html
		RUN chown -R www-data:www-data /usr/src/GIM





		# copy configuration files:
		COPY ./pifsc-resource-inventory/docker/php.ini /etc/php.ini
#		COPY ./pifsc-resource-inventory/docker/php.ini /usr/local/etc/php/php.ini
		COPY ./pifsc-resource-inventory/docker/httpd.conf /etc/apache2/sites-enabled/httpd.conf
		COPY ./pifsc-resource-inventory/docker/domain.crt /etc/ssl/certs/domain.crt
		COPY ./pifsc-resource-inventory/docker/domain.key /etc/ssl/private/domain.key
		COPY ./pifsc-resource-inventory/docker/ssl-passphrase /etc/ssl/private/ssl-passphrase

		# convert ssl-passphrase file to unix format
		RUN dos2unix /etc/ssl/private/ssl-passphrase

		# create the data_exports and logs folders (used in volumes)
#		RUN mkdir /usr/src/ODS/data_exports
#		RUN mkdir /usr/src/ODS/data_exports/formatted_reports
#		RUN mkdir /usr/src/ODS/logs

		# remove just the functions folder so these are not exposed to the apache server
#		RUN rm -rf /var/www/html/functions

		#enable mod ssl for apache
		RUN a2enmod ssl



#start the cron daemon service and httpd listener
CMD cron && /usr/sbin/apache2ctl -D FOREGROUND
