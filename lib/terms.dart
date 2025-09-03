import 'package:easy_saves/shared/colors.dart';
import 'package:easy_saves/shared/custom_text.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({super.key, required this.onAccepted});
  final VoidCallback onAccepted;

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  bool acceptedTerms = false;

  void submitForm() {
    if (acceptedTerms) {
      // Continuer le processus (inscription, validation, etc.)
      //print("Formulaire soumis !");
    } else {
      // Afficher une erreur ou un message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez accepter les termes et conditions")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Conditions d\'utilisation de l\'application',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
        backgroundColor: orange(),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenue dans notre application ! Avant de commencer à utiliser notre service, veuillez lire attentivement les conditions suivantes qui régissent votre utilisation de cette application.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '1. Acceptation des conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'En utilisant cette application, vous acceptez d\'être lié par ces conditions d\'utilisation. Si vous n\'êtes pas d\'accord avec ces conditions, veuillez ne pas utiliser l\'application.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '2. Utilisation autorisée',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vous vous engagez à utiliser cette application uniquement à des fins légales et conformément aux lois en vigueur dans votre pays.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '3. Propriété intellectuelle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tous les contenus présents dans cette application, y compris les textes, graphiques, logos, images et autres éléments, sont protégés par les droits d\'auteur et autres lois sur la propriété intellectuelle.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '4. Modifications des conditions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nous nous réservons le droit de modifier ces conditions à tout moment. Toute modification sera publiée sur cette page, et la version mise à jour sera effective dès sa publication.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '5. Application Easy Save',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'L\'application inclut une fonctionnalité dédiée à la gestion et à la sauvegarde des données utilisateur grâce à l\'application **Easy Save**. Cette application permet de sauvegarder, restaurer et gérer vos informations de manière sécurisée et efficace. En utilisant notre application, vous acceptez que certaines données puissent être synchronisées avec **Easy Save** pour un meilleur service et une gestion simplifiée de vos données.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '6. Gestion des Cours et ses Avantages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Notre application propose une fonctionnalité complète de gestion des cours pour les enseignants. Grâce à cette fonctionnalité, vous pouvez organiser vos cours, suivre leur progrèssion , et interagir avec les parents d\'eleves. Les avantages incluent une planification optimisée, des rappels de seance importantes, un suivi de vos gains, ainsi qu\'une meilleure organisation de votre emploi du temps. Cette gestion vous permet de maximiser votre efficacité et de ne jamais manquer d\'information importante.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '7. Limitation de responsabilité',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Nous ne serons en aucun cas responsables des dommages directs, indirects, accessoires ou consécutifs résultant de l\'utilisation ou de l\'incapacité à utiliser cette application.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                '8. Acceptation des modifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'En continuant à utiliser cette application après la publication des modifications, vous acceptez les conditions révisées.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              CheckboxListTile(
                activeColor: Colors.green,
                title: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "J'accepte les "),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            // Naviguer vers les CGU (ouvrir un lien ou une page)
                            //print("Naviguer vers les CGU");
                          },
                          child: const Text(
                            "termes et conditions",
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                value: acceptedTerms,
                onChanged: (bool? value) {
                  setState(() {
                    acceptedTerms = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              SizedBox(height: 5,),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20.0 , right: 8.0 , left: 8.0),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                    child:OutlinedButton(
                      onPressed: (acceptedTerms)?widget.onAccepted:null,
                      style: OutlinedButton.styleFrom(
                        backgroundColor:(acceptedTerms) ?Colors.green :  noir().withValues(alpha: 0.3),
                        elevation:(acceptedTerms) ?10 : 3,
                        side: BorderSide(color:(acceptedTerms) ? Colors.green.shade800 :  noir(), width: 2),// Custom border
                      ),
                      child: CustomText(
                        "Accepter les conditions",
                        fontWeight: FontWeight.w500,
                        color: noir(),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );

  }
}
