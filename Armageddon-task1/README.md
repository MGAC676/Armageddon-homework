Create a publically accesible bucket in GCP with Terraform.  You must complete the following tasks.
1) Terraform script
2) Git Push the script to your Github
3) Outpub file must show the public link
4) Must have an index.html file within



Create a publically accessuble web page with Terraform.  You must complete the following
1) Terraform Script with a VPC
2) Terraform script must have a VM within your VPC.
3) The VM must have the homepage on it.
4) The VM must have an publically accessible link to it.
5) You must Git Push your script to your Github.
6) Output file must show 1) Public IP, 2) VPC, 3) Subnet of the VM, 4) Internal IP of the VM.




You must complete the following scenerio.

A European gaming company is moving to GCP.  It has the following requirements in it's first stage migration to the Cloud:

A) You must choose a region in Europe to host it's prototype gaming information.  This page must only be on a RFC 1918 Private 10 net and can't be accessible from the Internet.
B) The Americas must have 2 regions and both must be RFC 1918 172.16 based subnets.  They can peer with HQ in order to view the homepage however, they can only view the page on port 80.
C) Asia Pacific region must be choosen and it must be a RFC 1918 192.168 based subnet.  This subnet can only VPN into HQ.  Additionally, only port 3389 is open to Asia. No 80, no 22.

Deliverables.
1) Complete Terraform for the entire solution.
2) Git Push of the solution to your GitHub.
3) Screenshots showing how the HQ homepage was accessed from both the Americas and Asia Pacific. 
