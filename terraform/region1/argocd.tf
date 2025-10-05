resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "kustomization_overlay" "argocd" {
  resources = [
    "../../infra/argocd/overlay/resources/${var.region}"
  ]
  namespace = "argocd"
}

resource "kustomization_resource" "p0" {
  for_each = data.kustomization_overlay.argocd.ids_prio[0]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.argocd.manifests[each.value])
    : data.kustomization_overlay.argocd.manifests[each.value]
  )
  depends_on = [kubernetes_namespace.argocd]
}

resource "time_sleep" "wait" {
  depends_on = [kustomization_resource.p0]

  create_duration = "5s"
}

resource "kustomization_resource" "p1" {
  for_each = data.kustomization_overlay.argocd.ids_prio[1]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.argocd.manifests[each.value])
    : data.kustomization_overlay.argocd.manifests[each.value]
  )

  depends_on = [time_sleep.wait]
}

resource "kustomization_resource" "p2" {
  for_each = data.kustomization_overlay.argocd.ids_prio[2]

  manifest = (
    contains(["_/Secret"], regex("(?P<group_kind>.*/.*)/.*/.*", each.value)["group_kind"])
    ? sensitive(data.kustomization_overlay.argocd.manifests[each.value])
    : data.kustomization_overlay.argocd.manifests[each.value]
  )

  depends_on = [kustomization_resource.p1]
}