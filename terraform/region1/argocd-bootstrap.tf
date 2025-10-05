resource "kubernetes_manifest" "argocd-projects" {
  for_each = fileset("../../bootstrap/${var.region}/", "project-*.yaml")
  manifest = yamldecode(file("../../bootstrap/${var.region}/${each.value}"))

  depends_on = [ kustomization_resource.p2 ]
}

resource "time_sleep" "wait_argo_deploy" {
  depends_on = [kubernetes_manifest.argocd-projects]

  create_duration = "90s"
}

resource "kubernetes_manifest" "argocd-apps" {
  for_each = fileset("../../bootstrap/${var.region}/", "app-*.yaml")
  manifest = yamldecode(file("../../bootstrap/${var.region}/${each.value}"))

  depends_on = [ time_sleep.wait_argo_deploy ]
}