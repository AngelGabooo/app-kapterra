# 🌱 Kaab Terra - Plataforma AgriTech para la Gestión de Café

Kaab Terra es una plataforma digital integral para la gestión, trazabilidad y comercialización de café. Conecta a productores, cooperativas y compradores en un ecosistema digital moderno y profesional.

---

## 📁 **Estructura del Proyecto**

### **1. Core (`lib/core/`)**

#### **1.1 Routes (`core/routes/`)**
| Archivo | Descripción |
|---------|-------------|
| `app_router.dart` | Configuración de todas las rutas de la aplicación usando GoRouter |
| `route_names.dart` | Constantes con los nombres de todas las rutas |

#### **1.2 Themes (`core/themes/`)**
| Archivo | Descripción |
|---------|-------------|
| `app_theme.dart` | Configuración de temas claro y oscuro con paleta de colores AgriTech |

#### **1.3 Constants (`core/constants/`)**
| Archivo | Descripción |
|---------|-------------|
| `app_constants.dart` | Constantes globales de la aplicación |

#### **1.4 Providers (`core/providers/`)**
| Archivo | Descripción |
|---------|-------------|
| `farm_provider.dart` | Provider para la gestión de fincas en memoria |
| `user_provider.dart` | Provider para la gestión del usuario y roles |

---

### **2. Características por Rol (`lib/features/`)**

## 👤 **Usuario - Autenticación**

### **Splash (`features/splash/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/splash_screen.dart` | Pantalla de carga inicial con animación |
| `presentation/cubit/splash_cubit.dart` | Manejo de estado con BLoC para el splash |
| `data/datasources/splash_local_datasource.dart` | Fuente de datos local para preferencias |
| `data/repositories/splash_repository_impl.dart` | Implementación del repositorio de splash |

### **Onboarding (`features/onboarding/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/onboarding_screen.dart` | Pantallas de introducción con 3 pasos deslizables |
| `data/models/onboarding_model.dart` | Modelo de datos para el onboarding |

### **Autenticación (`features/auth/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/login_screen.dart` | Inicio de sesión con email/contraseña y Google |
| `presentation/screens/register_screen.dart` | Registro de nuevo usuario con validaciones |
| `presentation/screens/forgot_password_screen.dart` | Recuperación de contraseña por email |
| `presentation/screens/select_user_type_screen.dart` | Selección de perfil (Productor, Cooperativa, Comprador, Técnico) |
| `presentation/screens/setup_profile_screen.dart` | Configuración inicial del perfil del productor |
| `presentation/widgets/login_form.dart` | Formulario de inicio de sesión |
| `presentation/widgets/register_form.dart` | Formulario de registro con validaciones |
| `presentation/widgets/social_login_button.dart` | Botón de inicio de sesión con Google |
| `data/models/user_type_model.dart` | Modelo de tipos de usuario |
| `data/models/register_model.dart` | Modelo de registro |
| `data/models/login_model.dart` | Modelo de inicio de sesión |

---

## 👨‍🌾 **Productor**

### **Fincas (`features/farms/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/my_farms_screen.dart` | Lista de fincas del productor con KPIs y estadísticas |
| `presentation/screens/farm_detail_screen.dart` | Detalle completo de una finca con información estratégica |
| `presentation/screens/edit_farm_screen.dart` | Edición de información de la finca |
| `presentation/screens/lot_detail_screen.dart` | Detalle de un lote con información técnica y productiva |
| `presentation/screens/edit_lot_screen.dart` | Edición de información del lote |
| `presentation/screens/create_lot_screen.dart` | Creación de un nuevo lote |
| `presentation/screens/lot_history_screen.dart` | Historial completo del lote con timeline |
| `presentation/widgets/farm_kpi_card.dart` | Tarjeta de KPIs para fincas |
| `presentation/widgets/farm_card.dart` | Tarjeta de finca para listados |
| `presentation/widgets/lot_card.dart` | Tarjeta de lote para listados |
| `presentation/widgets/farm_status_card.dart` | Tarjeta de estado de la finca |
| `data/models/farm_details_model.dart` | Modelo de detalles de finca |
| `data/models/lot_model.dart` | Modelo de lote |
| `data/models/farm_activity_model.dart` | Modelo de actividades de finca |

### **Dashboard (`features/dashboard/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/dashboard_screen.dart` | Dashboard principal del productor |
| `presentation/widgets/kpi_card.dart` | Tarjeta de KPIs para el dashboard |
| `presentation/widgets/production_chart.dart` | Gráfica de producción mensual |
| `presentation/widgets/alert_card.dart` | Tarjeta de alertas inteligentes |
| `presentation/widgets/quick_action_button.dart` | Botón de acciones rápidas |
| `presentation/widgets/farm_card.dart` | Tarjeta de finca en dashboard |
| `presentation/widgets/activity_timeline.dart` | Timeline de actividad reciente |
| `data/models/kpi_model.dart` | Modelo de KPIs |
| `data/models/alert_model.dart` | Modelo de alertas |
| `data/models/farm_summary_model.dart` | Modelo de resumen de finca |
| `data/models/activity_model.dart` | Modelo de actividad |

### **Registro de Fincas (`features/farm/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/register_farm_screen.dart` | Registro de nueva finca con formulario completo |
| `presentation/screens/farm_success_screen.dart` | Pantalla de éxito al registrar finca |
| `presentation/widgets/farm_form.dart` | Formulario de registro de finca |
| `presentation/widgets/farm_map.dart` | Mapa interactivo para ubicación |
| `presentation/widgets/farm_summary_card.dart` | Tarjeta de resumen de finca |
| `data/models/farm_model.dart` | Modelo de finca para registro |

### **Actividades (`features/activities/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/register_activity_screen.dart` | Registro de actividades agrícolas |
| `presentation/screens/activities_list_screen.dart` | Lista de actividades registradas |
| `presentation/screens/edit_activity_screen.dart` | Edición de actividades |
| `presentation/widgets/activity_type_card.dart` | Tarjeta de tipo de actividad |
| `presentation/widgets/evidence_uploader.dart` | Subida de evidencias |
| `presentation/widgets/traceability_summary.dart` | Resumen de trazabilidad |
| `data/models/activity_model.dart` | Modelo de actividad |
| `presentation/providers/activities_provider.dart` | Provider para actividades |

### **Costos (`features/costs/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/costs_list_screen.dart` | Lista y gestión de costos |

### **Perfil del Productor (`features/profile/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/profile_screen.dart` | Perfil del productor con estadísticas y logros |
| `presentation/widgets/profile_header.dart` | Encabezado del perfil |
| `presentation/widgets/profile_kpi_card.dart` | Tarjetas de KPIs del perfil |
| `presentation/widgets/digitalization_level.dart` | Nivel de digitalización |
| `presentation/widgets/achievement_badge.dart` | Insignias de logros |
| `presentation/widgets/production_chart_mini.dart` | Mini gráfica de producción |
| `presentation/widgets/quick_access_button.dart` | Botones de acceso rápido |
| `presentation/widgets/line_chart.dart` | Gráfica de líneas con puntos |
| `data/models/user_profile_model.dart` | Modelo de perfil de usuario |

### **Notificaciones (`features/notifications/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/notifications_screen.dart` | Centro de notificaciones |
| `presentation/widgets/notification_card.dart` | Tarjeta de notificación |
| `presentation/widgets/notification_kpi_card.dart` | KPIs de notificaciones |
| `presentation/widgets/notification_filter_chip.dart` | Filtros de notificaciones |
| `data/models/notification_model.dart` | Modelo de notificación |

---

## 🏢 **Cooperativa**

### **Cooperativa (`features/buyer/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/cooperative_dashboard_screen.dart` | Dashboard de la cooperativa |
| `presentation/screens/producers_screen.dart` | Lista de productores asociados |
| `presentation/screens/acopio_screen.dart` | Gestión de acopio de café |
| `presentation/screens/cooperative_profile_screen.dart` | Perfil de la cooperativa |
| `presentation/widgets/cooperative_kpi_card.dart` | KPIs de la cooperativa |
| `presentation/widgets/cooperative_chart.dart` | Gráfica de evolución mensual |
| `presentation/widgets/cooperative_map_preview.dart` | Mapa regional de productores |
| `presentation/widgets/cooperative_alert_card.dart` | Alertas institucionales |
| `presentation/widgets/producer_ranking_card.dart` | Ranking de productores |
| `presentation/widgets/acopio_card.dart` | Tarjeta de acopio |
| `presentation/widgets/acopio_form_dialog.dart` | Formulario de registro de acopio |
| `presentation/widgets/profile/cooperative_profile_stat_card.dart` | Estadísticas del perfil |
| `presentation/widgets/profile/cooperative_profile_info_row.dart` | Información del perfil |
| `presentation/widgets/profile/cooperative_profile_edit_dialog.dart` | Edición del perfil |
| `data/models/cooperative_model.dart` | Modelo de cooperativa |
| `data/models/producer_summary_model.dart` | Modelo de resumen de productor |
| `data/models/delivery_model.dart` | Modelo de entregas |
| `data/models/acopio_model.dart` | Modelo de acopio |

---

## 🛒 **Comprador**

### **Marketplace (`features/marketplace/`)**
| Archivo | Descripción |
|---------|-------------|
| `presentation/screens/marketplace_screen.dart` | Marketplace de cafés con lotes destacados |
| `presentation/screens/explore_screen.dart` | Exploración de catálogo con filtros avanzados |
| `presentation/screens/lot_detail_screen.dart` | Detalle de lote en el marketplace |
| `presentation/screens/make_offer_screen.dart` | Realizar oferta por un lote |
| `presentation/screens/negotiation_screen.dart` | Negociación con el productor |
| `presentation/screens/digital_passport_screen.dart` | Pasaporte digital del lote |
| `presentation/screens/buyer_profile_screen.dart` | Perfil del comprador |
| `presentation/widgets/marketplace_kpi_card.dart` | KPIs del marketplace |
| `presentation/widgets/lot_card.dart` | Tarjeta de lote en marketplace |
| `presentation/widgets/producer_card.dart` | Tarjeta de productor en marketplace |
| `presentation/widgets/category_chip.dart` | Chips de categorías de café |
| `presentation/widgets/recommendation_card.dart` | Recomendaciones IA |
| `presentation/widgets/explore_filter_chip.dart` | Filtros de exploración |
| `presentation/widgets/message_bubble.dart` | Burbuja de mensajes en negociación |
| `presentation/widgets/offer_card.dart` | Tarjeta de oferta en negociación |
| `presentation/widgets/negotiation_timeline.dart` | Timeline de negociación |
| `presentation/widgets/profile/*.dart` | Widgets del perfil del comprador |
| `data/models/lot_model.dart` | Modelo de lote en marketplace |
| `data/models/producer_model.dart` | Modelo de productor en marketplace |
| `data/models/message_model.dart` | Modelo de mensajes |
| `data/models/negotiation_model.dart` | Modelo de negociación |

---

## 📊 **Resumen de Rutas por Rol**

### **Flujo de Autenticación**

Splash (/)
→ Onboarding (/onboarding)
→ Login (/login)
→ Register (/register)
→ SelectUserType (/select-user-type)

text

### **Productor**
SetupProfile (/setup-profile)
→ RegisterFarm (/register-farm)
→ FarmSuccess (/farm-success)
→ Dashboard (/dashboard)
→ MyFarms (/my-farms)
→ FarmDetail (/farm-detail)
→ LotDetail (/lot-detail)
→ RegisterActivity (/register-activity)
→ LotHistory (/lot-history)
→ Notifications (/notifications)
→ Profile (/profile)
→ Costs (/costs)

text

### **Cooperativa**
CooperativeDashboard (/cooperative-dashboard)
→ Producers (/producers)
→ Acopio (/acopio)
→ CooperativeProfile (/cooperative-profile)

text

### **Comprador**
Marketplace (/marketplace)
→ Explore (/explore)
→ MarketplaceLotDetail (/marketplace-lot-detail)
→ MakeOffer (/make-offer)
→ Negotiation (/negotiation)
→ DigitalPassport (/digital-passport)
→ BuyerProfile (/buyer-profile)

text

---

## 🎨 **Paleta de Colores**

| Nombre | Código | Uso |
|--------|--------|-----|
| **Verde principal** | `#2E7D32` | Botones principales, encabezados |
| **Verde secundario** | `#66BB6A` | Acentos, elementos secundarios |
| **Dorado café** | `#D4A017` | Destacados, precios, premium |
| **Beige claro** | `#F8F5F0` | Fondos, tarjetas |
| **Café oscuro** | `#3E2723` | Textos principales |
| **Blanco** | `#FFFFFF` | Fondos, texto claro |

---

## 📱 **Tecnologías Utilizadas**

- **Flutter** - Framework UI
- **Dart** - Lenguaje de programación
- **GoRouter** - Navegación 2.0
- **Provider** - Manejo de estado
- **BLoC** - Manejo de estado (Splash)
- **SharedPreferences** - Persistencia local
- **Material Design 3** - Diseño UI
- **Google Fonts** - Tipografías

---

## 🚀 **Cómo Ejecutar**

```bash
# Clonar el repositorio
git clone [url-del-repositorio]

# Instalar dependencias
flutter pub get

# Ejecutar la aplicación
flutter run
📝 Estructura de Carpetas Completa
text
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── providers/
│   │   ├── farm_provider.dart
│   │   └── user_provider.dart
│   ├── routes/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   └── themes/
│       └── app_theme.dart
├── features/
│   ├── activities/
│   ├── auth/
│   ├── buyer/
│   ├── costs/
│   ├── dashboard/
│   ├── farm/
│   ├── farms/
│   ├── marketplace/
│   ├── notifications/
│   ├── onboarding/
│   ├── profile/
│   └── splash/
└── main.dart

📚 Módulos Principales

Módulo	Descripción
Auth	Autenticación y gestión de usuarios
Farms	Gestión de fincas y lotes
Dashboard	Panel principal del productor
Activities	Registro de actividades agrícolas
Marketplace	Comercialización de café
Buyer	Gestión para cooperativas
Profile	Perfiles de usuario
Notifications	Centro de notificaciones
Costs	Gestión de costos