/// Compile-time route path constants and named route identifiers for the NGO App.
///
/// Convention:
///   - [AppRoutes]     → full absolute paths (used with [context.go] / [context.push])
///   - [AppRouteNames] → named identifiers (used with [context.goNamed] / [context.pushNamed])
///
/// Path segments that are relative (used inside nested GoRoutes) are
/// intentionally kept as bare strings so GoRouter can compose them.
abstract final class AppRoutes {
  // ── Auth ────────────────────────────────────────────────────────────────────
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerify = '/otp-verify';

  // ── Shell tabs (absolute roots) ─────────────────────────────────────────────
  static const String dashboard = '/dashboard';
  static const String campaigns = '/campaigns';
  static const String data = '/data';
  static const String forms = '/forms';
  static const String profile = '/profile';

  // ── Dashboard sub-routes (relative segments used in GoRoute.path) ───────────
  static const String dashboardAnalytics = 'analytics';
  static const String dashboardHeatmap = 'heatmap';
  static const String dashboardActivity = 'activity'; // + /:activityId

  // ── Campaign sub-routes ─────────────────────────────────────────────────────
  static const String campaignCreate = 'create';
  // + /:campaignId  (detail)
  static const String campaignEdit = 'edit';
  static const String campaignParticipants = 'participants';
  static const String campaignAnalytics = 'analytics';

  // ── Data sub-routes ─────────────────────────────────────────────────────────
  static const String dataUpload = 'upload';
  // + /:fileId/raw | insights | analytics
  static const String dataRaw = 'raw';
  static const String dataInsights = 'insights';
  static const String dataFileAnalytics = 'analytics';

  // ── Forms sub-routes ────────────────────────────────────────────────────────
  static const String formCreate = 'create';
  // + /:formId  (detail)
  static const String formResponses = 'responses';
  static const String formShare = 'share';

  // ── Profile sub-routes ──────────────────────────────────────────────────────
  static const String ngoDetails = 'details';
  static const String documents = 'documents';
  static const String settings = 'settings';
  static const String settingsNotifications = 'notifications';
  static const String settingsPrivacy = 'privacy';

  // ── Global overlays (absolute — rendered above the shell) ───────────────────
  static const String notifications = '/notifications';
  static const String inbox = '/inbox';
  // + /:threadId  (chat)
  static const String help = '/help';
  static const String faq = 'faq';
  static const String support = 'support';

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Build a full campaign URL from an id.
  static String campaignDetail(String id) => '$campaigns/$id';

  /// Build a full campaign edit URL.
  static String campaignEditUrl(String id) => '$campaigns/$id/$campaignEdit';

  /// Build a full campaign participants URL.
  static String campaignParticipantsUrl(String id) =>
      '$campaigns/$id/$campaignParticipants';

  /// Build a full campaign analytics URL.
  static String campaignAnalyticsUrl(String id) =>
      '$campaigns/$id/$campaignAnalytics';

  /// Build a data file raw view URL.
  static String dataRawUrl(String fileId) => '$data/$fileId/$dataRaw';

  /// Build a data file insights URL.
  static String dataInsightsUrl(String fileId) => '$data/$fileId/$dataInsights';

  /// Build a data file analytics URL.
  static String dataAnalyticsUrl(String fileId) =>
      '$data/$fileId/$dataFileAnalytics';

  /// Build a form detail URL.
  static String formDetail(String id) => '$forms/$id';

  /// Build a form responses URL.
  static String formResponsesUrl(String id) => '$forms/$id/$formResponses';

  /// Build a form share URL.
  static String formShareUrl(String id) => '$forms/$id/$formShare';

  /// Build a chat thread URL.
  static String chatThread(String threadId) => '$inbox/$threadId';

  /// Build a dashboard activity detail URL.
  static String activityDetail(String activityId) =>
      '$dashboard/$dashboardActivity/$activityId';
}

/// Named route identifiers — mirrors [AppRoutes] semantically.
abstract final class AppRouteNames {
  // Auth
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String otpVerify = 'otp-verify';

  // Shell tabs
  static const String dashboard = 'dashboard';
  static const String campaigns = 'campaigns';
  static const String data = 'data';
  static const String forms = 'forms';
  static const String profile = 'profile';

  // Dashboard
  static const String dashboardAnalytics = 'dashboard-analytics';
  static const String dashboardHeatmap = 'dashboard-heatmap';
  static const String dashboardActivityDetail = 'activity-detail';

  // Campaigns
  static const String campaignCreate = 'campaign-create';
  static const String campaignDetail = 'campaign-detail';
  static const String campaignEdit = 'campaign-edit';
  static const String campaignParticipants = 'campaign-participants';
  static const String campaignAnalytics = 'campaign-analytics';

  // Data
  static const String dataUpload = 'data-upload';
  static const String dataRaw = 'data-raw';
  static const String dataInsights = 'data-insights';
  static const String dataFileAnalytics = 'data-file-analytics';

  // Forms
  static const String formCreate = 'form-create';
  static const String formDetail = 'form-detail';
  static const String formResponses = 'form-responses';
  static const String formShare = 'form-share';

  // Profile
  static const String ngoDetails = 'ngo-details';
  static const String documents = 'documents';
  static const String settings = 'settings';
  static const String settingsNotifications = 'settings-notifications';
  static const String settingsPrivacy = 'settings-privacy';

  // Global overlays
  static const String notifications = 'notifications';
  static const String inbox = 'inbox';
  static const String chat = 'chat';
  static const String help = 'help';
  static const String faq = 'faq';
  static const String support = 'support';
}
