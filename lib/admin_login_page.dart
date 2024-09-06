// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lakshya/get_invoice.dart';
import 'package:lakshya/main.dart';
import 'right_page.dart'; // Import RightPage here
import 'master_role_page.dart'; // Import MasterRolePage here
import 'state_page.dart'; // Import SelectPage here
import 'master_financial_year_page.dart'; // Import MasterFinancialYearPage here
import 'branch_page.dart'; // Import BranchPage here
import 'UpdateDuplicateBillsPage.dart'; // Import UpdateDuplicateBillsPage here
import 'invoice_page.dart'; // Import GenerateInvoicePage here
import 'edit_invoice_page.dart'; // Import EditInvoicePage here
import 'Nature_of_service_page.dart'; // Import NatureOfServicesPage here
import 'Client_Category_page.dart'; // Import ClientCategoryPage here
import 'user_page.dart'; // Import UserPage here
import 'country_page.dart'; // Import CountryPage here
import 'qualifications_page.dart'; // Import QualificationsPage here
import 'Districts_page.dart'; // Import DistrictsPage here
import 'field_area_page.dart'; // Import FieldAreaPage here
import 'zone_page.dart'; // Import ZonePage here
import 'shift_page.dart'; // Import ShiftPage here
import 'services_page.dart'; // Import ServicesPage here
import 'pf_code_page.dart'; // Import PFCodePage here
import 'ESIC_Code_page.dart'; // Import ESICCodePage here
import 'client_services_page.dart'; // Import ClientServicesPage here
import 'company_bank_page.dart'; // Import CompanyBanksPage here
import 'clint_verticle_page.dart'; // Import ClientVerticalPage here
import 'region_page.dart'; // Import RegionPage here
import 'emp_bank_page.dart'; // Import BankPage here
import 'additional_qualification_page.dart'; // Import AdditionalQualificationPage here
import 'client_page.dart'; // Import ClientPage here
import 'report_unit_page.dart'; // Import ReportUnitPage here
import 'report_client_page.dart'; // Import ReportClientPage here
import 'Unit_page.dart'; //Import unnitpage
import 'new_emp_page.dart'; //import new employee page here
import 'item_group.dart'; // Import ItemGroupPage here
import 'master_item.dart'; // Import MasterItemPage here
import 'supplier_page.dart'; // Import SupplierPage here
// ignore: unused_import
import 'attandance.dart'; // Import AttendancePage here
import 'location_admin.dart'; // Import LocationPage here
import 'emp_list.dart'; // Import EmployeeListPage here
import 'bill_rate_breakup.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  // Sign out method
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the splash screen or login page after sign out
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => SplashScreen()), // or LoginPage()
        (route) => false, // This will remove all routes in the stack
      );
    } catch (e) {
      print('Sign out failed: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red, // This sets the AppBar color to red
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
              color: Colors.white), // This sets the text color to white
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminLoginPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
                // Navigate to employees screen or perform employees-related action
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLocationPage()),
                );
                // Navigate to location screen or perform location-related action
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: () {
                // Navigate to create post screen or perform create post-related action
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    // Display admin image here
                    radius: 40,
                    // Replace 'admin_image.jpg' with the path to the admin's image
                    backgroundImage: AssetImage('assets/logo.jpeg'),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Mr. Rajan Tiwari', // Replace with admin's name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app,
                  color: Color.fromARGB(255, 225, 38, 38)),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Color.fromARGB(255, 225, 38, 38)),
              ),
              onTap: () => _signOut(context),
            ),
            ExpansionTile(
              title: const Text('Master'),
              children: <Widget>[
                ListTile(
                  title: const Text('Right'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RightPage()),
                    );
                    // Add functionality for Right
                  },
                ),
                ListTile(
                  title: const Text('Role'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MasterRolePage()),
                    );
                    // Add functionality for Role
                  },
                ),
                ListTile(
                  title: const Text('User'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddUserPage()),
                    );
                    // Add functionality for User
                  },
                ),
                ListTile(
                  title: const Text('State'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StatePage()),
                    );
                    // Add functionality for State
                  },
                ),
                ListTile(
                  title: const Text('Financial Year'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MasterFinancialYearPage()),
                    );
                    // Add functionality for Financial Year
                  },
                ),
                ListTile(
                  title: const Text('District'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DistrictPage()),
                    );
                    // Add functionality for District
                  },
                ),
                ListTile(
                  title: const Text('Branch'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BranchPage(),
                      ),
                    );

                    // Add functionality for Branch
                  },
                ),
                ListTile(
                  title: const Text('Qualification'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QualificationPage()),
                    );
                    // Add functionality for Qualification
                  },
                ),
                ListTile(
                  title: const Text('Nature of Service'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NatureOfServicesPage()),
                    );
                    // Add functionality for Nature of Service
                  },
                ),
                ListTile(
                  title: const Text('Field Area'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FieldAreaPage()),
                    );
                    // Add functionality for Field Area
                  },
                ),
                ListTile(
                  title: const Text('Zone'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ZonePage()),
                    );
                    // Add functionality for Zone
                  },
                ),
                ListTile(
                  title: const Text('Shift'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ShiftPage()),
                    );
                    // Add functionality for Shift
                  },
                ),
                ListTile(
                  title: const Text('Services'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ServicesPage()),
                    );
                    // Add functionality for Services
                  },
                ),
                ListTile(
                  title: const Text('Country'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountryPage()),
                    );
                    // Add functionality for Country
                  },
                ),
                ListTile(
                  title: const Text('Additional Qualification'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdditionalQualificationPage()),
                    );
                    // Add functionality for Additional Qualification
                  },
                ),
                ListTile(
                  title: const Text('Bank'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BankPage()),
                    );
                    // Add functionality for Bank
                  },
                ),
                ListTile(
                  title: const Text('Client Category'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientCategoryPage()),
                    );

                    // Add functionality for Client Category
                  },
                ),
                ListTile(
                  title: const Text('Professional Tax'),
                  onTap: () {
                    // Add functionality for Professional Tax
                  },
                ),
                ListTile(
                  title: const Text('LWF'),
                  onTap: () {
                    // Add functionality for LWF
                  },
                ),
                ListTile(
                  title: const Text('User Pending Approval'),
                  onTap: () {
                    // Add functionality for User Pending Approval
                  },
                ),
                ListTile(
                  title: const Text('User Permission Mapping'),
                  onTap: () {
                    // Add functionality for User Permission Mapping
                  },
                ),
                ListTile(
                  title: const Text('Region'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegionPage()),
                    );
                    // Add functionality for Region
                  },
                ),
                ListTile(
                  title: const Text('Client Vertical'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientVerticalPage()),
                    );
                    // Add functionality for Client Vertical
                  },
                ),
                ListTile(
                  title: const Text('Company Bank'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyBanksPage()),
                    );
                    // Add functionality for Company Bank
                  },
                ),
                ListTile(
                  title: const Text('Client Services'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientServicesPage()),
                    );
                    // Add functionality for Client Services
                  },
                ),
                ListTile(
                  title: const Text('ESIC Code'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ESICCodePage()),
                    );
                    // Add functionality for ESIC Code
                  },
                ),
                ListTile(
                  title: const Text('PF Code'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PFCodePage()),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Client'),
              children: <Widget>[
                ListTile(
                  title: const Text('Client'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Report Unit'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReportUnitPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Report Client'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportClientPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Unit'),
                  onTap: () {
                    // Add functionality for Unit
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UnitPage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Salary Rate Break Up'),
                  onTap: () {
                    // Add functionality for Salary Rate
                  },
                ),
                ListTile(
                  title: const Text('Bill Rate Break Up'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BillRateBreakupPage()),
                    );
                    // Add functionality for Bill Rate Break Up
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Employee Recruitment'),
              children: <Widget>[
                ListTile(
                  title: const Text('New Employee'),
                  onTap: () {
                    // Add functionality for New Employee
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewEmployeePage()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Edit Person Detail'),
                  onTap: () {
                    // Add functionality for Edit Person Detail
                  },
                ),
                ListTile(
                  title: const Text('Edit Communication Detail'),
                  onTap: () {
                    // Add functionality for Edit Communication Detail
                  },
                ),
                ListTile(
                  title: const Text('Edit Police Verification'),
                  onTap: () {
                    // Add functionality for Edit Police Verification
                  },
                ),
                ListTile(
                  title: const Text('Edit ExService Details'),
                  onTap: () {
                    // Add functionality for Edit ExService Details
                  },
                ),
                ListTile(
                  title: const Text('Edit Gunman Details'),
                  onTap: () {
                    // Add functionality for Edit Gunman Details
                  },
                ),
                ListTile(
                  title: const Text('Edit Training'),
                  onTap: () {
                    // Add functionality for Edit Training
                  },
                ),
                ListTile(
                  title: const Text('Edit Medical'),
                  onTap: () {
                    // Add functionality for Edit Medical
                  },
                ),
                ListTile(
                  title: const Text('Edit Employee Left'),
                  onTap: () {
                    // Add functionality for Edit Employee Left
                  },
                ),
                ListTile(
                  title: const Text('Employee Rejoin'),
                  onTap: () {
                    // Add functionality for Employee Rejoin
                  },
                ),
                ListTile(
                  title: const Text('Edit Employee Family'),
                  onTap: () {
                    // Add functionality for Edit Employee Family
                  },
                ),
                ListTile(
                  title: const Text('Employee Salary BreakUp'),
                  onTap: () {
                    // Add functionality for Employee Salary BreakUp
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Inventory'),
              children: <Widget>[
                ListTile(
                  title: const Text('Item'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MasterItemPage()),
                    );

                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Supplier'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MasterSupplierPage()),
                    );
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Material Receipt Note'),
                  onTap: () {
                    // Add functionality for Material Receipt Note
                  },
                ),
                ListTile(
                  title: const Text('Issue to Branch'),
                  onTap: () {
                    // Add functionality for Issue to Branch
                  },
                ),
                ListTile(
                  title: const Text('Issue to Employee'),
                  onTap: () {
                    // Add functionality for Issue to Employee
                  },
                ),
                ListTile(
                  title: const Text('Return From Employee'),
                  onTap: () {
                    // Add functionality for Return From Employee
                  },
                ),
                ListTile(
                  title: const Text('Item Group'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemGroupBottom()),
                    );
                    // Add functionality for Item Group
                  },
                ),
                ListTile(
                  title: const Text('Purchase Order'),
                  onTap: () {
                    // Add functionality for Purchase Order
                  },
                ),
                ListTile(
                  title: const Text('Indent'),
                  onTap: () {
                    // Add functionality for Indent
                  },
                ),
                ListTile(
                  title: const Text('Item Wastage'),
                  onTap: () {
                    // Add functionality for Item Wastage
                  },
                ),
                ListTile(
                  title: const Text('Opening Stock Branch'),
                  onTap: () {
                    // Add functionality for Opening Stock Branch
                  },
                ),
                ListTile(
                  title: const Text('Supplier Rate Chart'),
                  onTap: () {
                    // Add functionality for Supplier Rate Chart
                  },
                ),
                ListTile(
                  title: const Text('Return From Branch'),
                  onTap: () {
                    // Add functionality for Return From Branch
                  },
                ),
                ListTile(
                  title: const Text('Received Branch'),
                  onTap: () {
                    // Add functionality for Received Branch
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Inventory Reports'),
              children: <Widget>[
                ListTile(
                  title: const Text('Material Receipt Note'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Issue to Branch'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Issue to Employee'),
                  onTap: () {
                    // Add functionality for Material Receipt Note
                  },
                ),
                ListTile(
                  title: const Text('Item Stock'),
                  onTap: () {
                    // Add functionality for Issue to Branch
                  },
                ),
                ListTile(
                  title: const Text('Material Receipt Detail'),
                  onTap: () {
                    // Add functionality for Issue to Employee
                  },
                ),
                ListTile(
                  title: const Text('Central Store Stock'),
                  onTap: () {
                    // Add functionality for Return From Employee
                  },
                ),
                ListTile(
                  title: const Text('Issue to Branch Detail'),
                  onTap: () {
                    // Add functionality for Item Group
                  },
                ),
                ListTile(
                  title: const Text('Issue to Employee Detail'),
                  onTap: () {
                    // Add functionality for Purchase Order
                  },
                ),
                ListTile(
                  title: const Text('Current Stock Branch'),
                  onTap: () {
                    // Add functionality for Indent
                  },
                ),
                ListTile(
                  title: const Text('Return From Employee'),
                  onTap: () {
                    // Add functionality for Item Wastage
                  },
                ),
                ListTile(
                  title: const Text('Purchase Order'),
                  onTap: () {
                    // Add functionality for Opening Stock Branch
                  },
                ),
                ListTile(
                  title: const Text('Purchase Order Detail'),
                  onTap: () {
                    // Add functionality for Supplier Rate Chart
                  },
                ),
                ListTile(
                  title: const Text('Indent'),
                  onTap: () {
                    // Add functionality for Return From Branch
                  },
                ),
                ListTile(
                  title: const Text('Report Return From Branch'),
                  onTap: () {
                    // Add functionality for Received Branch
                  },
                ),
                ListTile(
                  title: const Text('Report Return From branch Detail'),
                  onTap: () {
                    // Add functionality for Received Branch
                  },
                ),
                ListTile(
                  title: const Text('Supplier Rate Chart'),
                  onTap: () {
                    // Add functionality for Received Branch
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Advance Module'),
              children: <Widget>[
                ListTile(
                  title: const Text('Adv Issue to Branch'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Adv Issue Employee'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Rpt Issue to Adv branch'),
                  onTap: () {
                    // Add functionality for Material Receipt Note
                  },
                ),
                ListTile(
                  title: const Text('Rpt Issue Adv employee'),
                  onTap: () {
                    // Add functionality for Issue to Branch
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Employee Salary'),
              children: <Widget>[
                ListTile(
                  title: const Text('Monthly Attendance (client)'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Approve Attendance'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Employee Salary'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Delete Salary'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Rpt Emp History'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Create Salary'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Delete Attendance'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report PF'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report ESI'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Blank Muster Roll'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Billing'),
              children: <Widget>[
                ListTile(
                  title: const Text('Update Duplicate Bills'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateDuplicateBillsPage()),
                    );
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Generate Invoice'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerateInvoicePage()),
                    );
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Edit Invoice'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditInvoicePage()),
                    );
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Bill Report'),
              children: <Widget>[
                ListTile(
                  title: const Text('Report GST Invoice'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InvoiceListScreen()),
                    );
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Report Client Ledger'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report GSTR1'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Receipt'),
              children: <Widget>[
                ListTile(
                  title: const Text('Receipt Entry'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Report Payment Receipt'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Employee Report'),
              children: <Widget>[
                ListTile(
                  title: const Text('Report Employee'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Report Police Verification'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Gunman'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Training'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Medical'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Employee Left'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Waiting for placement'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report ID Card'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Employee Rejoin'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Rpt New Join'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Rpt Bio-Data'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('Daily Attendance'),
              children: <Widget>[
                ListTile(
                  title: const Text('Import Daily Attendance'),
                  onTap: () {
                    // Add functionality for Item
                  },
                ),
                ListTile(
                  title: const Text('Daily Attendance Token Wise'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Daily Attendance System'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Report Employee Daily Attendance'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
                ListTile(
                  title: const Text('Rpt Attendance Summary Detail'),
                  onTap: () {
                    // Add functionality for Supplier
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePostPage()),
                );
              },
              child: const Text('Create Post'),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: PostList(),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _imageFile;
  final picker = ImagePicker(); // Initialize the ImagePicker instance

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source); // Use pickImage method instead of getImage

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadPost() async {
    if (_imageFile == null) {
      // Handle case where no image is selected
      return;
    }

    // Upload image to Firebase Storage
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask = storageReference.putFile(_imageFile!);

    await uploadTask.whenComplete(() async {
      // Get download URL
      String imageUrl = await storageReference.getDownloadURL();

      // Save post details to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'imageUrl': imageUrl,
        'timestamp': DateTime.now(),
        'likes': 0, // Initialize likes count
        'comments': [], // Initialize comments array
      });

      // Navigate back to home page after upload
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 300,
                  )
                : Container(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPost,
              child: const Text('Upload Post'),
            ),
          ],
        ),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot post = snapshot.data!.docs[index];
            return Card(
              child: Column(
                children: <Widget>[
                  Image.network(post['imageUrl']),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () {
                            // Increment likes count in Firestore
                            FirebaseFirestore.instance
                                .collection('posts')
                                .doc(post.id)
                                .update({
                              'likes': post['likes'] + 1,
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            // Implement comment functionality
                            // You can navigate to a comment screen or show a dialog for commenting
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AdminLoginPage(),
  ));
}
