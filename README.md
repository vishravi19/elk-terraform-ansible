# Description
This solution deploys Google Compute Instances in GCP using [Terraform](./IaC). The IaC code will write the IP addresses in a text file that will be used for building inventory. [Shell script](./ConfigMgmt/utisl/build_inventory.sh) is used to create simple inventory file for Ansible. An [Ansible playbook](./ConfigMgmt/es.yml) is used to install and configure ElasticSeach cluster on the newly created Compute Instances.

# Inputs for IaC

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| project_id | The ID of the project in which the resource belongs. | `string` | N/A | Yes |
| name | A unique name for the resource, required by GCE. Changing this forces a new resource to be created. | `string` | N/A | Yes |
| machine_type | The machine type to create. | `string` | N/A | Yes |
| zone | The zone that the machine should be created in. If it is not provided, the provider zone is used. | `string` | N/A | Yes |
| tags | A list of network tags to attach to the instance. | `list(string)` | N/A | Yes |
| boot_disk | Boot disk configuration. | <pre>object({<br>    image = string<br>    type  = string<br>    size  = string<br>  })</pre> | N/A | Yes |
| network_interface | Networks to attach to the instance. This can be specified multiple times. | <pre>list(object({<br>    network            = string<br>    subnetwork         = string<br>    subnetwork_project = string<br>  }))</pre> | N/A | Yes |
| metadata_startup_script | Path to startup script. | `string` | `null` | No |
| ssh_pub_key_path | Path to the SSH Public Key file | `string` | N/A | Yes |
| ssh_user | Username to login with | `string` | N/A | Yes |
| num_master_nodes | Number of master nodes to created | `number` | N/A | Yes |
| num_data_nodes | Number of data nodes to created | `number` | N/A | Yes |
| cmek_key_exists | Boolean value indicating whether to create a new CMEK key or use the existing key. If `false` then new key will be created else existing key will be retrieved based on variables starting with cmek_ | `bool` | N/A | Yes |
| cmek_keyring_name | Name of Keyring resource. | `string` | N/A | Yes |
| cmek_key_name | Name of Key resource | `string` | N/A | Yes |
| cmek_location | Location where CMEK resources must be created. | `string` | N/A | Yes |
| account_id | The Google service account ID. | `string` | N/A | Yes |
| service_account_scopes | Configration for new Service Account to be created and attached to the instances. | `list(string)` | N/A | Yes |

# Terraform resource being used:

* [google_compute_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)
* [google_kms_crypto_key_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_kms_crypto_key_iam)
* [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account)
* [google_kms_key_ring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring)
* [google_kms_crypto_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key)

# Permissions for Service Account:
Service Account used for executing IaC must have folllwing roles:
* Cloud KMS Admin - `roles/cloudkms.admin`
* Compute Admin - `roles/compute.admin`
* Service Account Admin - `roles/iam.serviceAccountAdmin`
* Service Account User - `roles/iam.serviceAccountUser`

# Prerequisites:
* Service Account with role mentioned above
* A Compute Engine Instance that can connect to newly created instances. This instance should be used to execute the code
* A SSH key pair
* Certificates generated for ElasticSearch cluster

# Network:
* Compute Engine instances created by this module will not have external IP. Cloud NAT was manually deployed to enable egress comminucation. Deploying Cloud NAT was not included in the IaC.
* Firewall rule to allow communication between nodes was created manually.

# Steps for execution:
* Go to IaC directory and initialize Terraform: `terraform init`
* Provide inputs in `terraform.tfvars` file. Relevant details about fields can be found in `variable.tf` description field as well as in `terraform.tfvars` file.
* Run `terraform plan -out tfplan` and verify the output
* Run `terraform apply tfplan`
* Once instances are deployed, go to `./ConfigMgmt/utils/` and  execute `build_inventory.sh` with following command line options:
    * $1: path to the file containing IP of master nodes.
    * $2: path to the file containing IP of data nodes.
    * $3: path where Ansible playbook is stored.
    * Example: `./build_inventory.sh ../../IaC/master.txt ../../IaC/data.txt ../es.yml`
* Install role from Ansible Galaxy: `ansible-galaxy install elastic.elasticsearch,v7.10.2`
* Go to `./ConfigMgmt/` and execute playbook `es.yml`: 
    * `ansible-playbook -i hosts --private-key </path/to/private_key_file> es.yml`

