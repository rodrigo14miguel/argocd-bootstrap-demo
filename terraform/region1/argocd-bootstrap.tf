resource "kubernetes_manifest" "argocd-resources" {
  for_each = fileset("../../bootstrap/${var.region}", "*.yaml")
  manifest = yamldecode(file("../../bootstrap/${var.region}/${each.value}"))

  depends_on = [ kustomization_resource.p2 ]
}
