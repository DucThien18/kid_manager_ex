import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kid_manager/models/notification_item.dart';
import 'package:kid_manager/widgets/app/app_button.dart';
import 'package:kid_manager/widgets/app/app_icon.dart';
import 'package:kid_manager/widgets/common/notification_modal.dart';

class ParentNotificationScreen extends StatefulWidget {
  const ParentNotificationScreen({super.key});

  @override
  State<ParentNotificationScreen> createState() =>
      _ParentNotificationScreenState();
}

class _ParentNotificationScreenState extends State<ParentNotificationScreen> {
  bool isLoading = false;

  final List<NotificationItemData> todayNotifications = [
    NotificationItemData(
      title: 'Bạn có lịch học môn thể dục',
      subtitle: 'Bắt đầu lúc 7h00',
      trailing: 'T2',
    ),
    NotificationItemData(
      title: 'Hôm nay là sinh nhật của...',
      subtitle: '12/12/2025',
      trailing: 'CN',
      isHighlighted: true,
    ),
    NotificationItemData(
      title: 'Thông báo: bạn đã đi vào vùng nguy hiểm',
      subtitle: 'Hôm nay, lúc 13h23',
      trailing: 'T7',
    ),
    NotificationItemData(
      title: 'Bạn có lịch học môn Toán',
      subtitle: 'Bắt đầu lúc 13h00',
      trailing: 'T6',
      isHighlighted: true,
    ),
  ];

  final List<NotificationItemData> yesterdayNotifications = [
    NotificationItemData(
      title: 'Bạn có lịch học môn Văn',
      subtitle: 'Bắt đầu lúc 9h15',
      trailing: 'T5',
    ),
  ];

  List<NotificationListItem> get listItems {
    return [
      if (todayNotifications.isNotEmpty) ...[
        NotificationListItem.section('Hôm nay'),
        ...todayNotifications.map(NotificationListItem.item),
      ],
      if (yesterdayNotifications.isNotEmpty) ...[
        NotificationListItem.section('Hôm qua'),
        ...yesterdayNotifications.map(NotificationListItem.item),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 14,
                        right: 14,
                      ),
                      child: AppIcon(
                        path: "assets/icons/menu.svg",
                        type: AppIconType.svg,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Thông báo",
                        style: TextStyle(
                          color: Color(0xFF222B45),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 14,
                        right: 14,
                      ),
                      child: AppIcon(
                        path: "assets/icons/icon_search.svg",
                        type: AppIconType.svg,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: 400,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter,
                      color: const Color(0xFFEDF1F7),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    final item = listItems[index];

                    final bool showDivider =
                        index < listItems.length - 1 &&
                        listItems[index + 1].type ==
                            NotificationListItemType.item;

                    Widget content;

                    if (item.type == NotificationListItemType.section) {
                      content = SectionHeader(title: item.sectionTitle!);
                    } else {
                      final data = item.data!;
                      content = NotificationItem(
                        title: data.title,
                        subtitle: data.subtitle,
                        trailing: data.trailing,
                        isHighlighted: data.isHighlighted,
                        type: NotificationType.schedule,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            useRootNavigator: true,
                            builder: (dialogContext) {
                              return NotificationModal(
                                height: 420,
                                onBackgroundTap: () {
                                  Navigator.of(
                                    dialogContext,
                                    rootNavigator: true,
                                  ).pop();
                                },
                                child: const BirthdayNotificationContent(),
                              );
                            },
                          );
                        },
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        content,

                        if (showDivider)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Container(
                              width: double.infinity,
                              decoration: const ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.8,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFFEDF1F7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BirthdayNotificationContent extends StatelessWidget {
  const BirthdayNotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    const String _birthdayBannerSvg = '''
    <svg width="325" height="124" viewBox="0 0 325 124" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M203.442 74.5487C205.485 70.1687 207.115 66.0419 208.434 62.2864C202.089 62.7523 195.38 63.0541 188.341 63.1416C182.072 63.2209 176.059 63.1188 170.337 62.882C172.456 66.0733 174.629 69.6345 176.787 73.6087C177.898 75.6687 179.015 77.8249 180.089 80.0838C183.551 87.3033 186.039 94.0549 187.843 99.9702C191.754 94.9834 196.028 88.7852 200.057 81.3113C201.295 79.0049 202.43 76.746 203.442 74.5487Z" fill="#3BA27A"/>
    <path d="M141.344 73.4963C142.698 71.6431 144.054 69.8123 145.413 67.9584L147.506 65.1133C148.486 63.7764 149.463 62.457 150.443 61.1201C144.804 60.4672 138.878 59.6231 132.718 58.5581C126.175 57.4055 119.965 56.0843 114.115 54.6823C114.85 58.7832 115.806 63.261 117.111 68.0189L117.961 71.0203C118.193 71.7553 118.421 72.5022 118.649 73.2492C120.007 77.5722 121.489 81.5766 122.992 85.2585C123.495 86.4552 123.98 87.5971 124.485 88.725C125.218 90.3771 125.954 91.9661 126.667 93.461C128.177 91.4049 129.703 89.3466 131.206 87.2856C131.848 86.4149 132.489 85.5443 133.128 84.6624C135.862 80.9467 138.611 77.212 141.344 73.4963Z" fill="#446DB7"/>
    <path d="M43.1314 27.9921L7.06418 49.0251C8.06216 42.6109 8.82665 35.2734 9.04092 27.1679C9.24316 19.7204 8.91716 12.9121 8.35348 6.87091C12.8032 9.98377 17.5431 13.1333 22.5476 16.2544C29.6551 20.6737 36.5407 24.5679 43.1314 27.9921ZM241.379 57.9953C235.903 58.9998 230.605 59.8385 225.509 60.5197C230.176 65.2258 235.371 71.2337 240.368 78.6716C243.972 84.0288 246.821 89.1581 249.083 93.8039C251.526 88.4989 254.011 82.332 256.18 75.344C258.649 67.3752 260.189 60.0289 261.168 53.6457C254.973 55.2283 248.36 56.7108 241.379 57.9953Z" fill="#F14947"/>
    <path d="M8.71948 15.9402C8.52511 15.8055 8.48051 15.5486 8.61522 15.3542L12.4292 9.6151C12.5583 9.42144 12.8144 9.37122 13.0088 9.50595C13.2032 9.64068 13.2478 9.89752 13.1187 10.0912L9.29908 15.831C9.20763 15.9627 9.06891 16.0377 8.93051 16.0271C8.84973 16.0204 8.78361 15.9947 8.71948 15.9402ZM32.1882 33.6132C31.9903 33.496 31.9282 33.2357 32.0629 33.0414L37.1846 24.787C37.3017 24.5891 37.5564 24.5277 37.75 24.6568C37.9422 24.7747 38.01 25.0342 37.8753 25.2286L32.7544 33.4886C32.6741 33.6189 32.5178 33.6904 32.3682 33.6812C32.3162 33.6765 32.2508 33.6564 32.1882 33.6132ZM9.14971 26.2059C8.95188 26.0888 8.88973 25.8285 9.00761 25.6363L16.7848 12.3976C16.902 12.1998 17.1615 12.132 17.3537 12.2499C17.5459 12.3677 17.6137 12.6273 17.4966 12.8251L9.71718 26.047C9.63913 26.1941 9.48283 26.2657 9.32688 26.2516C9.26365 26.2483 9.19825 26.2282 9.14971 26.2059ZM8.2839 37.2215C8.0917 37.1036 8.02951 36.8433 8.15865 36.6497L21.2961 15.4568C21.4084 15.2653 21.6679 15.1976 21.8623 15.3323C22.0545 15.4502 22.1167 15.7104 21.9876 15.9041L8.85572 37.0962C8.7755 37.2265 8.61919 37.298 8.46956 37.2888C8.4176 37.2841 8.35147 37.2584 8.2839 37.2215ZM16.3007 43.8181C16.1274 43.6693 16.094 43.411 16.2428 43.2376L32.9139 22.3531C33.062 22.1741 33.3203 22.1408 33.4944 22.2952C33.6678 22.4441 33.7004 22.6968 33.5523 22.8758L16.8813 43.7602C16.7876 43.8751 16.6636 43.9311 16.5308 43.9197C16.4478 43.8962 16.3649 43.8726 16.3007 43.8181ZM6.83288 49.363C6.63924 49.2339 6.59391 48.9715 6.72302 48.7778L27.1452 19.0168C27.2799 18.8224 27.5367 18.7778 27.7311 18.9126C27.9191 19.0424 27.9701 19.3041 27.8354 19.4985L7.41321 49.2595C7.32103 49.3856 7.18011 49.4437 7.04734 49.4324C6.96314 49.4432 6.89773 49.4231 6.83288 49.363ZM123.011 85.2784C123.095 85.2676 123.193 85.2777 123.296 85.2815C124.404 85.3668 125.207 86.3304 125.121 87.4319C125.08 87.951 124.842 88.4099 124.497 88.74L123.011 85.2784ZM130.417 83.4823C131.416 82.9992 132.596 83.429 133.078 84.4172C133.11 84.4872 133.15 84.5791 133.179 84.6667C132.537 85.5318 131.902 86.4017 131.257 87.2899C130.531 87.281 129.837 86.8569 129.506 86.1518C129.007 85.1602 129.418 83.971 130.417 83.4823ZM117.977 71.0234C118.153 71.1034 118.371 71.1551 118.59 71.1725C119.698 71.2578 120.635 70.4288 120.721 69.3273C120.802 68.2321 119.987 67.2699 118.891 67.1832C118.171 67.1279 117.524 67.4684 117.127 68.0163L117.977 71.0234ZM128.091 74.6717C129.18 74.7536 130.002 75.7206 129.915 76.8165C129.835 77.9173 128.874 78.7436 127.784 78.6561C126.694 78.5743 125.873 77.6128 125.96 76.5113C126.041 75.4162 127.001 74.5898 128.091 74.6717ZM125.276 59.4278C126.367 59.5152 127.187 60.4767 127.101 61.5782C127.02 62.6733 126.059 63.4997 124.97 63.4178C123.88 63.3359 123.059 62.3688 123.146 61.273C123.226 60.1722 124.169 59.3425 125.276 59.4278ZM135.222 66.4146C136.311 66.4964 137.132 67.4579 137.046 68.5594C136.965 69.6545 136.005 70.4865 134.914 70.399C133.825 70.3171 133.004 69.3557 133.085 68.2549C133.171 67.159 134.115 66.3293 135.222 66.4146ZM145.92 63.9875C146.658 64.0406 147.265 64.4987 147.555 65.112L145.463 67.9627C144.428 67.8167 143.704 66.8941 143.783 65.8278C143.852 64.7285 144.813 63.9022 145.92 63.9875ZM260.057 59.9886L248.047 57.0764C247.834 57.0239 247.679 56.7928 247.748 56.5783C247.818 56.3638 248.026 56.2113 248.246 56.2743L260.256 59.1865C260.469 59.239 260.624 59.4701 260.555 59.6846C260.506 59.8849 260.324 60.0226 260.123 60.0087C260.092 59.9899 260.074 59.9864 260.057 59.9886ZM258.913 65.2686L237.175 59.132C236.961 59.0683 236.828 58.8343 236.897 58.6198C236.96 58.4005 237.189 58.2682 237.403 58.3375L259.141 64.4742C259.355 64.5379 259.488 64.7719 259.424 64.9856C259.376 65.186 259.181 65.3083 258.996 65.2922C258.976 65.2719 258.947 65.2699 258.913 65.2686ZM257.55 70.6739L225.394 60.9169C225.18 60.8475 225.047 60.6191 225.116 60.3991C225.18 60.1853 225.414 60.0523 225.622 60.1167L257.778 69.8738C257.998 69.9424 258.13 70.1708 258.062 70.3909C257.996 70.5878 257.821 70.6903 257.637 70.6798C257.599 70.6961 257.585 70.6751 257.55 70.6739ZM256.048 75.7433L230.147 66.0228C229.936 65.9359 229.821 65.711 229.905 65.4775C229.991 65.2608 230.216 65.1461 230.45 65.2301L256.346 74.9626C256.557 75.0495 256.678 75.2793 256.589 75.5135C256.526 75.6929 256.352 75.801 256.167 75.785C256.131 75.7669 256.084 75.7614 256.048 75.7433ZM254.35 80.7637L234.289 70.9965C234.077 70.8984 233.999 70.6515 234.097 70.439C234.201 70.2258 234.441 70.1434 234.654 70.2415L254.709 80.0094C254.922 80.1075 255.005 80.3537 254.907 80.5662C254.825 80.7308 254.666 80.82 254.498 80.8073C254.446 80.8026 254.398 80.7804 254.35 80.7637ZM252.506 85.666L239.536 78.111C239.339 77.9994 239.276 77.7392 239.376 77.5379C239.488 77.3464 239.748 77.2786 239.943 77.379L252.914 84.934C253.111 85.0511 253.174 85.3114 253.073 85.5071C252.995 85.6541 252.839 85.7257 252.689 85.7165C252.616 85.7259 252.569 85.7093 252.506 85.666ZM251.05 89.2451L243.95 85.0133C243.758 84.8954 243.69 84.6359 243.807 84.4381C243.925 84.2459 244.184 84.1781 244.377 84.296L251.477 88.5277C251.669 88.6456 251.731 88.9059 251.62 89.103C251.542 89.2501 251.38 89.3224 251.23 89.3075C251.164 89.2875 251.112 89.2827 251.05 89.2451ZM94.1382 49.1567L63.5794 77.1219C62.3206 72.6377 61.157 67.7415 60.2165 62.4512C58.426 52.3498 57.8302 43.1444 57.8668 35.2103C63.4913 37.7831 69.5377 40.3529 75.9763 42.8205C82.2715 45.2382 88.3539 47.3352 94.1382 49.1567ZM294.256 43.313C288.853 45.3298 283.604 47.1213 278.553 48.7216C282.352 52.2269 286.287 56.1312 290.275 60.4854C296.381 67.1406 301.531 73.6852 305.856 79.7656C308.124 72.8847 310.272 64.8547 311.876 55.7989C313.215 48.2674 313.931 41.3072 314.28 35.0396C308.069 37.8632 301.396 40.6493 294.256 43.313Z" fill="#F9B53F"/>
    <path d="M163.944 61.5616C160.382 61.3025 156.813 60.9817 153.179 60.6007C84.0559 53.2112 32.5015 24.0164 1.42429 0.830073C1.05872 0.563331 0.54777 0.629353 0.26416 0.997107C-0.0018362 1.36829 0.0592842 1.8856 0.427058 2.16918C31.6811 25.4868 83.5121 54.8343 153.004 62.2503C156.119 62.5899 159.22 62.8628 162.27 63.0967C164.3 63.2568 166.333 63.3937 168.332 63.495C235.35 67.3201 289.594 48.4483 324.242 31.235C324.644 31.029 324.819 30.5325 324.616 30.1078C324.409 29.7006 323.918 29.5243 323.494 29.7332C288.287 47.2585 232.645 66.488 163.944 61.5616Z" fill="#F79748"/>
    </svg>
    ''';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ===== TOP SVG DECOR =====
          SvgPicture.string(
            _birthdayBannerSvg,
            width: 325,
            height: 120,
            fit: BoxFit.contain,
          ),

          // ===== ICON =====
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A7DFF), width: 2),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/icon_party.svg',
                width: 50,
                height: 50,
              ),
            ),
          ),

          // ===== TITLE =====
          const Text(
            'Chúc mừng sinh nhật',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          // ===== DESCRIPTION =====
          const Text(
            'Hôm nay là sinh nhật\ncủa Nguyễn Văn A',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 0),

          // ===== BUTTON =====
          AppButton(
            text: "Xác nhận",
            width: 300,
            height: 50,
            backgroundColor: Color(0xFF3A7DFF),
            fontWeight: FontWeight.w700,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class NotificationItemData {
  final String title;
  final String subtitle;
  final String trailing;
  final bool isHighlighted;

  NotificationItemData({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isHighlighted = false,
  });
}

enum NotificationListItemType { section, item }

class NotificationListItem {
  final NotificationListItemType type;
  final String? sectionTitle;
  final NotificationItemData? data;

  NotificationListItem.section(this.sectionTitle)
    : type = NotificationListItemType.section,
      data = null;

  NotificationListItem.item(this.data)
    : type = NotificationListItemType.item,
      sectionTitle = null;
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF4A4A4A),
          fontSize: 15,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.20,
        ),
      ),
    );
  }
}
