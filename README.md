# nwai-alz-iac

Azure Landing Zone IaC demo — Terraform-based Azure Landing Zone (ALZ) scaffold with management groups, core governance policies, and RBAC baked in.

## Repository layout

```
environments/
  demo/                     # Root Terraform config for the demo environment
modules/
  management-groups/        # MG hierarchy + subscription-to-MG associations
  policy/                   # Custom policy set + assignments
  rbac/                     # AAD security groups + role assignments
```

## Management group hierarchy

```
nwai-root
├── nwai-platform
│   ├── nwai-management
│   ├── nwai-connectivity
│   └── nwai-identity
├── nwai-landing-zones
│   ├── nwai-corp
│   └── nwai-online
├── nwai-stage
├── nwai-sandbox
└── nwai-decommissioned
```

See [modules/management-groups/main.tf](modules/management-groups/main.tf).

## What gets created

### Management groups module — [modules/management-groups](modules/management-groups/)
- **10 management groups** in the hierarchy above.
- **Subscription → MG associations** for `connectivity`, `corp`, `online`, `stage`, `sandbox`, `decommissioned`, plus optional `management` and `identity`.

### Policy module — [modules/policy](modules/policy/)
- **1 custom initiative** (`nwai-core-governance`) at **root** — allowed locations + required tags (`Environment`, `Owner`, `CostCenter`).
- **4 policy assignments**:
  - `nwai-core-gov` — core initiative at **root**.
  - `nwai-sbx-vm-sku` — allowed VM SKUs at **sandbox**.
  - `nwai-sbx-stgsku` — allowed storage SKUs at **sandbox**.
  - `nwai-decom-pip` — deny public IPs at **decommissioned**.

### RBAC module — [modules/rbac](modules/rbac/)
- **10 AAD security groups** (prefix configurable via `group_prefix`, default `nwai`).
- **10 role assignments** binding each group to an MG scope (see table below).

## Access model

Role assignments at an MG **inherit down** to child MGs and their subscriptions.

| Group | Role | Scope (MG) | What they can do |
|---|---|---|---|
| `nwai-platform-admins` | Owner | Platform | Full control of Management, Connectivity, Identity (incl. RBAC + policy) |
| `nwai-global-readers` | Reader | Root | Read-only across the entire hierarchy |
| `nwai-management-contributors` | Contributor | Management | Manage resources in management subs |
| `nwai-network-contributors` | Network Contributor | Connectivity | Manage network resources in connectivity subs |
| `nwai-identity-contributors` | Contributor | Identity | Manage resources in identity subs |
| `nwai-landingzone-contributors` | Contributor | Landing Zones | Manage resources across Corp + Online |
| `nwai-corp-contributors` | Contributor | Corp | Manage resources in corp subs |
| `nwai-online-contributors` | Contributor | Online | Manage resources in online subs |
| `nwai-stage-contributors` | Contributor | Stage | Manage resources in stage subs |
| `nwai-sandbox-contributors` | Contributor | Sandbox | Manage resources in sandbox subs |

**Notes**
- Standard `Contributor` does **not** grant policy write or RBAC write — contributors can manage resources inside their subscriptions only.
- `Decommissioned` has no contributor group — only `global-readers` can view it.
- `Stage`, `Sandbox`, `Decommissioned` are siblings of `Platform` under Root, so `platform-admins` (Owner on Platform) do **not** have Owner there.

## Subscription wiring (demo env)

Subscriptions are resolved by **display name** from the tenant at plan time — see [environments/demo/data.tf](environments/demo/data.tf).

| Role | Source | Lands under MG |
|---|---|---|
| Connectivity | display name `connectivity` | `nwai-connectivity` |
| Online (seed) | display name `azure-learning-path-pay-as-you-go` | `nwai-online` |
| Sandbox | display name `dev-subs` | `nwai-sandbox` |
| Production | `var.production_subscription_ids` | `nwai-online` |
| Corp | `var.corp_subscription_ids` | `nwai-corp` |
| Stage | `var.stage_subscription_ids` | `nwai-stage` |
| Decommissioned | `var.decommissioned_subscription_ids` | `nwai-decommissioned` |

Not wired in the demo env (module supports them): `management_subscription_id` → Management, `security_subscription_id` → Identity.

## Required inputs

Set in `environments/demo/terraform.tfvars` (not committed):

```hcl
tenant_id                 = "<tenant-guid>"
bootstrap_subscription_id = "<sub-id-used-by-provider-auth>"

# Optional
corp_subscription_ids           = []
stage_subscription_ids          = []
decommissioned_subscription_ids = []
production_subscription_ids     = []
allowed_locations               = ["uaenorth", "uaecentral", "eastus", "westus"]
required_tags                   = ["Environment", "Owner", "CostCenter"]
sandbox_allowed_vm_skus         = ["Standard_B2s", "Standard_B2ms", "Standard_D2s_v5"]
sandbox_allowed_storage_skus    = ["Standard_LRS", "Standard_GRS"]
group_prefix                    = "nwai"
```

See [environments/demo/variables.tf](environments/demo/variables.tf) for the full list and defaults.

## Usage

```bash
cd environments/demo
terraform init
terraform plan  -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

## Providers

- `azurerm` — authenticates against `bootstrap_subscription_id`; `resource_provider_registrations = "none"` to avoid auto-registration churn.
- `azuread` — authenticates against `tenant_id` for AAD group creation.

See [environments/demo/providers.tf](environments/demo/providers.tf) and [environments/demo/versions.tf](environments/demo/versions.tf).

## Prerequisites

- Terraform ≥ 1.5
- Azure CLI authenticated (`az login`) with rights to create management groups and assign roles at tenant root
- `Microsoft.Graph` permissions sufficient to create AAD security groups
