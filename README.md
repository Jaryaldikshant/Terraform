# 🚀 Azure Virtual Machine with Terraform

This project shows how I created a **Linux Virtual Machine in Microsoft Azure** using **Terraform (HCL language)** as a beginner.

---

## 🌱 What is Terraform?

**Terraform** is an open-source tool developed by HashiCorp that helps you **create, manage, and destroy cloud resources** using simple code (in `.tf` files). 

Instead of clicking around on the Cloud portal, Terraform allows you to write code to define what your infrastructure should look like.

---

## 🔧 Tools Used

- **Terraform** – for writing infrastructure as code
- **Cloud Provider** – cloud platform where the VM is deployed
- **VS Code** – for writing Terraform code
- **Command Line / Terminal** – to run Terraform commands

---

## 📁 Folder Structure

```
azure-vm-terraform/
├── vm.tf           # Main Terraform code to create the VM
├── terraform.tf        # Shows the user provider code
├── provider.tf      # shows the provider
├── terraform.tfstate # Created after running Terraform (don't edit)
├── README.md         # This file
```

---

## 🧠 Terraform Concepts Used

Here are the basic Terraform concepts I used in this project:

<!-- | Concept | Description |
|--------|-------------|
| `provider` | Tells Terraform which cloud to use (e.g. Azure) |
| `resource` | Describes the cloud services we want to create (e.g. VM, VNet) |
<!-- | `variable` | Lets us reuse values like username or SSH key | -->
<!-- | `output` | Shows useful info like the public IP after the VM is created | -->
<!-- | `file()` | Loads the SSH public key from a file |
| `.tf` files | Files where we write Terraform code | --> 

| Concept            | Description                                                                                      |
|--------------------|--------------------------------------------------------------------------------------------------|
| `provider`         | Tells Terraform which cloud to use (e.g., Azure)                                                  |
| `resource`         | Describes the cloud services we want to create (e.g., VM, VNet)                                   |
| `variable`         | Lets us reuse values like usernames or SSH keys across different resources (e.g., `prefix`)      |
| `file()`           | Loads the SSH public key from a file to configure the VM's authentication                        |
| `.tf` files        | Files where we write Terraform code (e.g., defining resources, variables, and outputs)            |
| Interpolation      | Used to inject values dynamically into strings (e.g., `"${var.prefix}-vm"` creates a dynamic name)|


---

## 💡 What This Project Does

This project uses Terraform to create:

- A **Resource Group**
- A **Virtual Network (VNet)** and **Subnet**
- A **Public IP address**
- A **Network Interface**
- A **Linux Virtual Machine (Ubuntu 24.04 LTS)**

The VM is created with:
- Size: `Standard_B1s`
- Authentication: **SSH public key**
- Region: **East US**

---

## 🛠️ How to Run This Project

> ⚠️ You need an Azure account and SSH public key first.

### 1. Install Terraform  
https://developer.hashicorp.com/terraform/downloads

### 2. Login to Azure  
```bash
az login
```

### 3. Initialize Terraform  
```bash
terraform init
```

### 4. Preview Changes  
```bash
terraform plan
```

### 5. Apply and Create VM  
```bash
terraform apply
```

---



Once the VM is created, use the command to see the output:

```bash
terraform show
```

---

## 📌 Important Notes

- Don't commit your private SSH keys to GitHub.
- Make sure to **destroy the VM** when not needed to avoid charges:
```bash
terraform destroy
```

---

## 🧑‍💻 Author

**Dikshant Jaryal**  
Beginner in Terraform & Azure | Exploring DevOps & Cloud ☁️

---

## 📎 License

This project is open-source and free to use.