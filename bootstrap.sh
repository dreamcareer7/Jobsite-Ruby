sudo su -

# Automatically move to the project folder on login
echo "cd /vagrant" >> /home/vagrant/.bashrc


# Configure Elasticsearch

# either of the next two lines is needed to be able to access "localhost:9200" from the host os
echo "network.bind_host: 0" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

# enable dynamic scripting
echo "script.inline: on" >> /etc/elasticsearch/elasticsearch.yml
echo "script.indexed: on" >> /etc/elasticsearch/elasticsearch.yml


# Install the Elasticsearch Head plugin

if [ ! -d "/usr/share/elasticsearch/plugins/head/" ]; then
  echo "-----> Installing the Elasticsearch Head plugin"
  /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head
fi
