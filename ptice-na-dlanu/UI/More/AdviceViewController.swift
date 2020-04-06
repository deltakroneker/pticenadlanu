//
//  AdviceViewController.swift
//  ptice-na-dlanu
//
//  Created by Jelena Krmar on 05/04/2020.
//  Copyright © 2020 Nikola Milic. All rights reserved.
//

import UIKit

class BirdwatchAdvice {
    let title: String
    let explanation: String
    var isCollapsed: Bool = true
    let imageName: String
    var showShare: Bool
    
    init(title: String, explanation: String, imageName: String, showShare: Bool = false) {
        self.title = title
        self.explanation = explanation
        self.imageName = imageName
        self.showShare = showShare
    }
}

class AdviceViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars & Lets
    weak var coordinator: AppCoordinator?
    
    let dataSource = [
        BirdwatchAdvice(title: "1. Garderoba za ovu priliku", explanation: "Zamislite da idete u školu u pidžami ili da igrate fudbal u odelu i kravati. Izgledali biste prilično čudno, zar ne? Za svaku aktivnost vam je neophodna odgovarajuća garderoba, u tom slučaju posmatranje ptica nije izuzetak. Za ovu priliku odaberite tamne, kamuflažne boje tako da ptice ne vide da im prilazite. Bez obzira kakvo je vreme napolju, obavezno sa sobom imajte komad garderobe koji vas može ugrejati, zaštititi od kiše ili sunca – bićete iznenađeni da pasionirano posmatrate ptice duže nego što ste očekivali.", imageName: ""),
        BirdwatchAdvice(title: "2. Spakujte svoju torbu za posmatranje ptica", explanation: "Nijedan dobar posmatrač ptica ne napušta dom bez ključnih stvari u svojoj torbi: dvogleda (bilo kakvog), olovke i beležnice za beleženje viđenih vrsta ptica i vodiča za prepoznavanje ptica (knjige). Ako još uvek nemate nijednu takvu knjigu, i naša aplikacija će pomoći :). Obavezno proučite reči i izraze koje se nalaze u vodiču jer će vam to olakšati prepoznavanje ptica. I ne zaboravite da ponesete piće i užinu jer posmatranje ptica može da potraje. Takođe, možete poneti foto-aparat, ali ne zaboravite da isključite blic (pogledaj narednu tačku).", imageName: ""),
        BirdwatchAdvice(title: "3. Izbegavajte uznemiravanje ptica", explanation: "Zamislite da ste obična kukavica koja je upravo prešla 8.000 kilometara iz Velike Britanije u Angolu. Sletiš na granu, očajnički pokušavaš da uhvatiš nekog insekta da se prehraniš i na posletku odmoriš. Odjednom, grupa ljudi koja galami juri ka vama. O, ne! Grabljivci! Skupiš snagu i raširiš umorna krila i opet poletiš ka nebu. Večera će morati da sačeka.\n\nBez obzira koliko se zabavljate dok posmatrate ptice, uvek imajte na umu da je bezbednost i dobrobit ptica na prvom mestu. Plašenje kod ptica izaziva veliki stres i ometa ih u ishrani, odgajanju mladih i odmaranju. Zato, hodajte polako i tiho, razgovarajte u tišini, isključite zvuk na mobilnom telefonu i, pre svega, ne približavajte se previše jer tome služi dvogled! Sve što treba je da pronađete dobro mesto za sedenje, budete strpljivi i pustite ptice da vam same priđu. Ptice je mnogo zanimljivije gledati dok su mirne nego dok beže u paničnom strahu.", imageName: ""),
        BirdwatchAdvice(title: "4. Ostavite gnezdo na miru", explanation: "Bilo koji roditelj će vam reći da je briga o bebama naporan posao. Kada je u pitanju odgajanje ptića, posebno je važno držati se na udaljenosti. Uznemiravanje gnezda može uzrokovati da roditelji odlete sa gnezda, glad kod ptića jer ih niko ne hrani, ili olakšati grabljivicama pronalazak jaja ili ptića. Ako se previše zadržavate oko gnezda, roditelji mogu postati toliko oprezni da potpuno napuste gnezdo. Najbolja stvar koju možete da učinite ako naiđete na gnezdo je da se tiho udaljite.", imageName: ""),
        BirdwatchAdvice(title: "5. Koristite osmatračnice za ptice", explanation: "Zastori za posmatranje ptica i osmatračnice su sjajni objekti koja vam omogućavaju da imate sjajan pogled na ptice bez da otkrijete svoje prisustvo. Ovi objekti su takođe savršena mesta za zaštitu od sunca ili ispijanje flaše toplog čaja tokom kišnih i vetrovitih dana. Raspitajte se ili potražite na internetu gde postoje osmatračnice za ptice u vašoj blizini.", imageName: ""),
        BirdwatchAdvice(title: "6. Poštujte pravila domaćina", explanation: "Bez obzira da li idete u kuću svog prijatelja na večeru ili idete da gledate ptice, uvek je važno biti dobar gost. Ne zaboravite da imate obzira i budete pažljivi prema upravljačima zaštićenog područja koje posećujete. Zatvorite sve kapije iza sebe, držite se staze i nemojte uzurpirati privatan posed jer ćete na taj način zaljubljenicima u ptice stvoriti lošu reputaciju.", imageName: ""),
        BirdwatchAdvice(title: "7. Ne ostavljate tragove iza sebe", explanation: "Neka vaš moto bude: „Ne uzimam ništa i ništa ne ostavljam iza sebe“. Nikad ne bacajte smeće i ne gazite po vegetaciji – tako možete da uništite domove ptica koje želte da posmatrate.", imageName: ""),
        BirdwatchAdvice(title: "8. Posmatraj ptice bilo gde", explanation: "Mislite da u vašem okruženju nema zanimljivih ptica? Razmislite ponovo! Ptica ima svuda, samo je potrebno da počnete da ih primećujete i tražite. Budite kreativni kada tražite mesto gde ćete posmatrati ptice: parkovi, dvorišta, trgovi, kanali, pa čak i krovovi. Ako tokom zime postavite hranilicu za ptice u svoj vrt ili na terasu, možete posmatrati svoje pernate prijatelje iz udobnosti svog doma.", imageName: ""),
        BirdwatchAdvice(title: "9. Nema ptica? Nikakav problem!", explanation: "Čak i iskusni posmatrači ptica imaju loše dane. Ako krenete sa previše očekivanja samo da biste otkrili da su sve ptice u vašem okruženju odlučile da provedu dan negde drugde, nemojte se zavaravati. Umesto toga probudite u sebi detektiva i uočavajte tragove koje su ptice ostavile za sobom: otiske nogu, perje, čak i ostatke hrane. Gde može da živi ptica koja ima otisak stopala sa opnom između prstiju? Zašto su razbijene ljušture puževa razbacane po ravnoj steni?\n\nAlternativa, pokušajte da slušate, a ne da gledate. Da li čujete bilo koju pticu? Ako čujete, kako zvuči – brzo, sporo, visoko, nisko? Možete li pretpostaviti o kojoj se vrsti ptice radi? Konsultujte našu aplikaciju i istražite koja se to ptica oglašava, a uskoro ćete to moći i sami.", imageName: ""),
        BirdwatchAdvice(title: "10. Širite radost!", explanation: "Kada ste napolju sa dvogledom i vodičem za prepoznavanje ptica, prolaznici će biti radoznali i zanimaće ih šta radite. Budite promoteri posmatranja ptica, odvojite vreme da objasnite i podelite sa njima svoja najzanimljivija zapažanja. Možete ih inspirisati da vam se pridruže i postanu posmatrači ptica! Budite ljubazni prema svojim kolegama posmatračima ptica jer oni imaju znanje i zanimljive savete koji vam mogu koristiti. Što više prijateljstava steknete, imaćete bogatiju i živopisniju zajednicu posmatrača ptica, koja će vam pomoći da širite ljubav i poštovanje prema prirodi mnogo dalje.", imageName: "", showShare: true)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 16, right: 0)
    }
}

// MARK: - TableView
extension AdviceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdviceIntroCell", for: indexPath)
            cell.textLabel?.text = "Čuli ste da posmatranje ptica može biti zabavno i želite da što pre započnete ovu novu aktivnost u prirodi. Pre nego što izletite iz kuće, sačekajte! Imamo nekoliko važnih saveta koje treba da znate. Ovi saveti će vam pomoći da se odlično provedete, budete osigurani i pažljivi prema pticama."
            
            return cell
        }
        
        let advice = dataSource[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdviceCell", for: indexPath) as! AdviceCell
        cell.advice = advice
        cell.row = indexPath.row
        cell.delegate = self
        
        return cell
    }
}

// MARK: - AdviceDelegate
extension AdviceViewController: AdviceDelegate {
    func toggleAdvice(_ row: Int) {
        dataSource[row].isCollapsed.toggle()
        tableView.reloadData()
    }
    
    func shareTapped() {
        shareApp(message: "Instalirajte besplatnu mobilnu aplikaciju za prepoznavanje ptica „Ptice na dlanu“")
    }
}
