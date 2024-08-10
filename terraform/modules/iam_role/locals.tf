locals {
  // Shrink these lists down to their unique elements
  trusted_services       = toset(var.trusted_services)
  trusted_identities     = toset(var.trusted_identities)
  trusted_saml_providers = toset(var.trusted_saml_providers)
}
