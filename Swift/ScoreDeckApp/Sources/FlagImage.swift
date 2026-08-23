import SwiftUI
import XvaluappCore

/// Renders a participant's flag from the `Flag-<code>` assets carried over
/// from the legacy app's bundled artwork (`RedBullApp/*.png`, copied into
/// this target's asset catalog unmodified — see the migration notes). Falls
/// back to a plain text badge for any country code that doesn't have
/// matching artwork yet, instead of showing a broken image the way the
/// legacy `Resultado1`/`Detalle` cells silently would (`UIImage(named:)`
/// returning nil renders nothing there, with no visible fallback at all).
struct FlagImage: View {
    let countryCode: String
    var size: CGFloat = 24

    var body: some View {
        if UIImage(named: "Flag-\(countryCode)") != nil {
            Image("Flag-\(countryCode)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size * 1.4, height: size)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .overlay(RoundedRectangle(cornerRadius: 2).strokeBorder(.separator, lineWidth: 0.5))
        } else {
            Text(countryCode)
                .font(.system(size: size * 0.5, weight: .semibold))
                .frame(width: size * 1.4, height: size)
                .background(Color.secondary.opacity(0.15), in: RoundedRectangle(cornerRadius: 2))
        }
    }
}

/// A menu-based picker over `Countries.all`, showing each option's flag next
/// to its name — replaces the legacy `ComboBox` + `Subtitulados.Banderas`
/// combination for this one use case.
struct CountryPicker: View {
    @Binding var selection: String

    var body: some View {
        Menu {
            ForEach(Countries.all) { country in
                Button {
                    selection = country.code
                } label: {
                    // `country.name` is a runtime String from XvaluappCore
                    // (English only there — see Countries.swift), not a
                    // literal, so it needs an explicit LocalizedStringKey
                    // wrap to hit the catalog instead of silently skipping
                    // lookup the way `Label(country.name, ...)` would.
                    Label(LocalizedStringKey(country.name), systemImage: selection == country.code ? "checkmark" : "")
                }
            }
        } label: {
            HStack {
                FlagImage(countryCode: selection, size: 18)
                Text(LocalizedStringKey(Countries.named(selection)))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
