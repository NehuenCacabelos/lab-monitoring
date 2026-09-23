📊 Infrastructure & Container Monitoring Stack (Prometheus + Grafana + Node Exporter + cAdvisor)Proyecto de infraestructura como código (IaC) para el monitoreo en tiempo real del sistema operativo host y de los contenedores Docker en ejecución. Utiliza contenedores orquestados con Docker Compose y provisioning declarativo para evitar configuraciones manuales.📸 Vista Previa del Dashboard🏗️ Arquitectura del SistemaEl flujo de métricas y la interacción entre contenedores se distribuye de la siguiente manera:graph LR
    SubGraph1[Host Server] -->|Métricas de SO/HW| NE[Node Exporter :9100]
    SubGraph2[Docker Daemon / cgroups] -->|Métricas de Contenedores| CA[cAdvisor :8080 red interna]
    P[Prometheus :9090] -->|Scrape cada 15s| NE
    P -->|Scrape cada 15s| CA
    G[Grafana :3000] -->|Consulta métricas| P
🚀 Servicios y RedServicioPuerto HostPuerto InternoDescripciónNode Exporter:9100:9100Agente para la recolección de métricas del host (CPU, RAM, Discos, Red).cAdvisorNo publicado:8080Analizador de uso de recursos y rendimiento de los contenedores Docker vía cgroups.Prometheus:9090:9090Base de datos de series temporales configurada para hacer scraping cada 15s.Grafana:3000:3000Plataforma de visualización de métricas y tableros interactivos.Nota sobre cAdvisor: No expone puertos al host para evitar conflictos de puertos locales. Prometheus interactúa con él directamente a través de la red interna de Docker.🛠️ Automatización e Infraestructura como Código (IaC)Toda la plataforma se aprovisiona automáticamente al iniciar el entorno, sin requerir clics ni ajustes manuales en las interfaces web:Aprovisionamiento de Data Source: grafana/provisioning/datasources/prometheus.ymlConecta automáticamente Prometheus como fuente de datos predeterminada al arrancar Grafana.Aprovisionamiento de Dashboards: grafana/provisioning/dashboards/dashboards.ymlConfigura a Grafana para escanear y cargar de forma automática los paneles en la carpeta local.Carga de Dashboard Personalizado: grafana/dashboards/node-exporter.jsonTablero unificado que combina las métricas de hardware del sistema (Node Exporter) con paneles personalizados para el consumo de CPU por contenedor individual (cAdvisor).📂 Estructura del Proyecto.
├── docker-compose.yml
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   ├── provisioning/
│   │   ├── datasources/
│   │   │   └── prometheus.yml
│   │   └── dashboards/
│   │       └── dashboards.yml
│   └── dashboards/
│       └── node-exporter.json
├── screenshots/
│   └── grafana-dashboard.png
└── .gitignore
⚡ Guía de DespliegueRequisitos PreviosDocker Desktop o Docker Engine con Docker Compose instalado.Pasos para EjecutarClonar el repositorio:git clone https://github.com/tu-usuario/tu-repositorio.git
cd tu-repositorio
Levantar el stack en segundo plano:docker compose up -d
Abrir en el navegador:Grafana: http://localhost:3000 (acceso directo al dashboard unificado)Prometheus Targets: http://localhost:9090/targets (verificación de estado UP de recolectores)(Recordá actualizar la imagen screenshots/grafana-dashboard.png en tu repo con la nueva captura donde ya figura el panel de uso por contenedor).`
