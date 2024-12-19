output "helm_release_status" {
  description = "The status of the Helm release"
  value       = helm_release.elasticsearch.status
}

output "helm_release_namespace" {
  description = "The namespace where Helm release is deployed"
  value       = helm_release.elasticsearch.namespace
}

# Output the Elasticsearch service hostname
output "elasticsearch_service_name" {
  description = "The name of the Elasticsearch service"
  value       = "elasticsearch-service.${var.namespace}.svc.cluster.local"
}

# Output the full URL to Elasticsearch (assuming a ClusterIP service within the Kubernetes cluster)
output "elasticsearch_url" {
  description = "The full URL to Elasticsearch service"
  value       = "http://${helm_release.elasticsearch.name}-svc.${var.namespace}.svc.cluster.local:${var.service_port}"
}

output "elasticsearch_host" {
  value = "${helm_release.elasticsearch.name}.${var.namespace}.svc.cluster.local"
  description = "The Elasticsearch hostname to use in Kibana"
}

output "elasticsearch_port" {
  value = var.service_port
  description = "The Elasticsearch port to use in Kibana"
}


/*
# If you are using LoadBalancer, output the external IP or DNS name
output "elasticsearch_loadbalancer_ip" {
  description = "The external IP or DNS name of the Elasticsearch LoadBalancer (if available)"
  value       = kubernetes_service.elasticsearch.load_balancer_ingress[0].hostname
  depends_on  = [helm_release.elasticsearch]
}
*/