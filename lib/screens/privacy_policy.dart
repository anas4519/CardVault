import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Last updated: October 08, 2024',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Interpretation and Definitions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Interpretation',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Definitions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'For the purposes of this Privacy Policy:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildDefinitionList(context, constraints),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Collecting and Using Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Types of Data Collected',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Personal Data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildBulletList(context, [
                    'Email address',
                    'First name and last name',
                    'Usage Data',
                  ]),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Usage Data',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Usage Data is collected automatically when using the Service. Usage Data may include information such as Your Device\'s Internet Protocol address (e.g. IP address), browser type, browser version, the pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Information Collected while Using the Application',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  _buildBulletList(context, [
                    'Pictures and other information from your Device\'s camera and photo library',
                  ]),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the Company\'s servers and/or a Service Provider\'s server or it may be simply stored on Your device. You can enable or disable access to this information at any time, through Your Device settings.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Use of Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildUseOfPersonalDataList(context),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'We may share Your personal information in the following situations:',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildSharingPersonalInfoList(context),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Retention of Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Transfer of Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Your information, including Personal Data, is processed at the Company\'s operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Delete Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Our Service may give You the ability to delete certain information about You from within the Service.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information. You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Please note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Disclosure of Your Personal Data',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Business Transactions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Law enforcement',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Under certain circumstances, the Company may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Other legal requirements',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildBulletList(context, [
                    'Comply with a legal obligation',
                    'Protect and defend the rights or property of the Company',
                    'Prevent or investigate possible wrongdoing in connection with the Service',
                    'Protect the personal safety of Users of the Service or the public',
                    'Protect against legal liability'
                  ]),
                  Text(
                    'Security of Your Personal Data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Children\'s Privacy',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'If We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent\'s consent before We collect and use that information.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Links to Other Websites',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party\'s site. We strongly advise You to review the Privacy Policy of every site You visit.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Changes to this Privacy Policy',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.04),
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'If you have any questions about this Privacy Policy, You can contact us:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  SelectableText(
                    '•	By email: versevibe45@gmail.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefinitionList(
      BuildContext context, BoxConstraints constraints) {
    final definitions = [
      {
        'term': 'Account',
        'definition':
            'means a unique account created for You to access our Service or parts of our Service.'
      },
      {
        'term': 'Affiliate',
        'definition':
            'means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.'
      },
      {
        'term': 'Application',
        'definition':
            'refers to CardVault, the software program provided by the Company.'
      },
      {'term': 'Company', 'definition': 'refers to CardVault, the Company.'},
      {'term': 'Country', 'definition': 'refers to: Delhi, India.'},
      {
        'term': 'Device',
        'definition':
            'means any device that can access the Service such as a computer, a cellphone or a digital tablet.'
      },
      {
        'term': 'Personal Data',
        'definition':
            'is any information that relates to an identified or identifiable individual.'
      },
      {'term': 'Service', 'definition': 'refers to the Application.'},
      {
        'term': 'Service Provider',
        'definition':
            'means any natural or legal person who processes the data on behalf of the Company.'
      },
      {
        'term': 'Usage Data',
        'definition':
            'refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself.'
      },
      {
        'term': 'You',
        'definition': 'means the individual accessing or using the Service.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: definitions
          .map((def) => Padding(
                padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.02),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${def['term']}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: def['definition']),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildBulletList(BuildContext context, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Icon(Icons.circle, size: 6),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(item,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildUseOfPersonalDataList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Company may use Personal Data for the following purposes:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 8.0),
        _buildBulletList(context, [
          'To provide and maintain our Service, including to monitor the usage of our Service.',
          'To manage Your Account: to manage Your registration as a user of the Service.',
          'To perform a contract: the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.',
          'To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application\'s push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including security updates, when necessary or reasonable for their implementation.',
          'To provide You with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or inquired about unless You have opted not to receive such information.'
        ]),
      ],
    );
  }

  Widget _buildSharingPersonalInfoList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Company may share Your personal information in the following situations:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 8.0),
        _buildBulletList(context, [
          'With Service Providers: We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.',
          'For business transfers: We may share or transfer Your personal information in connection with, or during negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of Our Service to another company.',
          'With Affiliates: We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy.',
          'With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions.',
          'With other users: when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside.',
          'With Your consent: We may disclose Your personal information for any other purpose with Your consent.'
        ]),
      ],
    );
  }
}
