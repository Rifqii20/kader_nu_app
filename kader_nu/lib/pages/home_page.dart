import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kader NU'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Nahdlatul Ulama',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/logo_nu.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nahdlatul Ulama (NU) adalah organisasi Islam terbesar di Indonesia. Didirikan pada 31 Januari 1926 oleh KH. Hasyim Asy\'ari, organisasi ini bertujuan untuk mengawal dan melestarikan ajaran Islam yang moderat di tengah perkembangan zaman.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'NU memiliki peran penting dalam pendidikan, sosial, dan keagamaan di Indonesia. Melalui berbagai lembaga pendidikan seperti pesantren, madrasah, dan sekolah, NU berkontribusi besar dalam mencetak generasi yang berakhlakul karimah dan berilmu pengetahuan.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Secara sosial, NU aktif dalam berbagai kegiatan kemanusiaan, termasuk bantuan bencana, program kesehatan, dan pemberdayaan ekonomi umat. Di bidang keagamaan, NU berusaha menjaga nilai-nilai Islam Ahlusunnah wal Jamaah melalui dakwah, pengajian, dan pengembangan literasi keagamaan.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Visi NU adalah menciptakan masyarakat yang adil, makmur, dan beradab, yang berlandaskan pada nilai-nilai Islam rahmatan lil \'alamin. Dengan semboyan "Menegakkan Islam Nusantara," NU terus berupaya untuk beradaptasi dengan perkembangan zaman tanpa mengabaikan nilai-nilai tradisional yang menjadi ciri khas Islam di Indonesia.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
