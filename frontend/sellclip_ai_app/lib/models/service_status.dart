class ServiceStatusRequest {
  const ServiceStatusRequest(this.name, this.path);

  final String name;
  final String path;
}

class ServiceStatus {
  const ServiceStatus(this.name, this.message, this.isHealthy);

  final String name;
  final String message;
  final bool isHealthy;
}
