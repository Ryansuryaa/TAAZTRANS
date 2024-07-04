import 'package:get/get.dart';

import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/dashboard_user/bindings/dashboard_user_binding.dart';
import '../modules/dashboard_user/views/dashboard_user_view.dart';
import '../modules/data_pelanggan/bindings/data_pelanggan_binding.dart';
import '../modules/data_pelanggan/views/data_pelanggan_view.dart';
import '../modules/data_reservasi/bindings/data_reservasi_binding.dart';
import '../modules/data_reservasi/views/data_reservasi_view.dart';
import '../modules/detail_mobil/bindings/detail_mobil_binding.dart';
import '../modules/detail_mobil/views/detail_mobil_view.dart';
import '../modules/detail_pelanggan/bindings/detail_pelanggan_binding.dart';
import '../modules/detail_pelanggan/views/detail_pelanggan_view.dart';
import '../modules/form_mobil/bindings/form_mobil_binding.dart';
import '../modules/form_mobil/views/form_mobil_view.dart';
import '../modules/form_pesan_mobil/bindings/form_pesan_mobil_binding.dart';
import '../modules/form_pesan_mobil/views/form_pesan_mobil_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/process/bindings/process_binding.dart';
import '../modules/process/views/process_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_user/bindings/profile_user_binding.dart';
import '../modules/profile_user/views/profile_user_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/welcome_screen/bindings/welcome_screen_binding.dart';
import '../modules/welcome_screen/views/welcome_screen_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_SCREEN,
      page: () => const WelcomeScreenView(),
      binding: WelcomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROCESS,
      page: () => const ProcessView(),
      binding: ProcessBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FORM_MOBIL,
      page: () => const FormMobilView(),
      binding: FormMobilBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_USER,
      page: () => const ProfileUserView(),
      binding: ProfileUserBinding(),
    ),
    GetPage(
      name: _Paths.DATA_PELANGGAN,
      page: () => const DataPelangganView(),
      binding: DataPelangganBinding(),
    ),
    GetPage(
      name: _Paths.DATA_RESERVASI,
      page: () => const DataReservasiView(),
      binding: DataReservasiBinding(),
    ),
    GetPage(
      name: _Paths.FORM_PESAN_MOBIL,
      page: () => const FormPesanMobilView(),
      binding: FormPesanMobilBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_USER,
      page: () => const DashboardUserView(),
      binding: DashboardUserBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_MOBIL,
      page: () => const DetailMobilView(),
      binding: DetailMobilBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PELANGGAN,
      page: () => const DetailPelangganView(),
      binding: DetailPelangganBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
  ];
}
