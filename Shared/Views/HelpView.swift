//
//  HelpView.swift
//  Tempo
//
//  Created by Romain Penchenat on 17/09/2021.
//

import SwiftUI

struct HelpView: View {
    
    @EnvironmentObject var link:TempoLink
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Vous avez perdu Tempo ?")
                    .modifier(HighlightText())
                Spacer()
                Button(action: { link.needHelp = false }) {
                    Image("CloseIcon")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.tBlack)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 16))
            .background(Color.tSand)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Paramétrer Tempo").modifier(HighlightText())
                        Text("Lorsque Tempo s'illumine en vert, il attend que vous le configurez... Donnez lui les clés de votre réseau en suivant ces 3 étapes. ").modifier(DetailText())
                        Text("1. Connectez-vous au réseau WiFi ouvert nommé “TempoByMeaningful”.").modifier(DetailText())
                        Text("2. Ouvrez l’app Tempo.").modifier(DetailText())
                        Text("3. Transmettez les identifiants de votre réseau Wifi à votre Tempo.").modifier(DetailText())
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Régler les problèmes de connexion").modifier(HighlightText())
                        Text("- Vérifiez que votre appareil est bien connecté sur le même réseau WiFi que Tempo.").modifier(DetailText())
                        Text("- Vérifiez que Tempo s'illumine en blanc. Si Tempo est bleu ou violet, il est en train de se connecter au réseau WiFi le plus proche.").modifier(DetailText())
                        Text("- Forcez le redémarrage de Tempo en le branchant puis en le débranchant 3s après.").modifier(DetailText())
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Assistance technique").modifier(HighlightText())
                        Text("Le développeur n'a pas souhaité divulgé son identité afin d'éviter des agressions non désirées. Merci de vous débrouiller avec le propriétaire de ce compte Apple pour régler vos soucis. Cependant, nous ferons notre possible afin que Tempo soit heureux. Nous vous recommandons d'ailleurs de réguliérement le sortir au grand air : sur les falaises d'Étretat, au sommet du Mont Blanc, dans la campagne limougeaude, dans les forêts de Bourgogne ou sur la dune du pilat. Notre service client ne pourra pas vous aider si vous ne respectez pas les besoins primaires de ce tendre sablier. Pensez également à ses allergies : gluten, doliprane, bananes et pains au chocolat... Si il s'approche d'une des ces substances nocives, il faudra être réactif ! Trouvez une bonne boulangerie rapidement puis achetez une belle et savoureuse chocolatine. Oui, il raffole des chocolatines et celles-ci peuvent résoudrent la pluspart de ses caprices.").modifier(DetailText())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 40)
            }
        }
        .background(Color.tCream.edgesIgnoringSafeArea(.all))
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
