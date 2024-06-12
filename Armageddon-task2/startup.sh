#Thanks to Remo
#!/bin/bash
# Update and install Apache2
apt update
apt install -y apache2

# Start and enable Apache2
systemctl start apache2
systemctl enable apache2

# GCP Metadata server base URL and header
METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
METADATA_FLAVOR_HEADER="Metadata-Flavor: Google"

# Use curl to fetch instance metadata
local_ipv4=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/network-interfaces/0/ip")
zone=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/zone")
project_id=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/project/project-id")
network_tags=$(curl -H "${METADATA_FLAVOR_HEADER}" -s "${METADATA_URL}/instance/tags")

# Create a simple HTML page and include instance details
cat <<EOF > /var/www/html/index.html
<html><body>
<h2>This Was Truly Challenging My Brain Thank You Theo</h2>
<h2>Together We Inspire Together We Achieve, Stand As One Brothers</h2>
<h3>If You Are Trying To Complete This Assignment By Yourself, You Are Crazy!</h3>
<iframe src="https://giphy.com/embed/fWAlpoPgxSF47aqh8R" width="1000" height="400" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/TOEIAnimationUK-goku-dragon-ball-son-fWAlpoPgxSF47aqh8R">via GIPHY</a></p>
<p><b>Instance Name:</b> $(hostname -f)</p>
<p><b>Instance Private IP Address: </b> $local_ipv4</p>
<p><b>Zone: </b> $zone</p>
<p><b>Project ID:</b> $project_id</p>
<p><b>Network Tags:</b> $network_tags</p>
</body></html>
EOF