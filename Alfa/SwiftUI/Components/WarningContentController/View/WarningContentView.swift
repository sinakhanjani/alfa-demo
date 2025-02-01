//
//  WarningContentView.swift
//  TEST
//
//  Created by Sina khanjani on 12/12/1399 AP.
//

import SwiftUI

/// This class `WarningContentView` is used to manage specific logic in the application.
struct WarningContentView: View {
    
    @ObservedObject var alertContentModelData: AlertContentModelData = AlertContentModelData(alertContent: AlertContent(title: .none, subject: "", description: ""))
    
/// This variable `yesButton` is used to store a specific value in the application.
    var yesButton: onTappedHandler!
    
/// This variable `body` is used to store a specific value in the application.
    var body: some View {
        VStack {
            VStack(alignment: .trailing, spacing: DEFAULT_PADDING_08) {
                HStack {
                    VStack(alignment: .trailing) {
                        Text(alertContentModelData.alertContent.title.value)
                            .font(.iranSans(.bold, size: 17))
                        .bold()
                        
                        Divider()
                            .background(Color.AlfaBlue)
                    }
                    .foregroundColor(.AlfaBlue)
                    
                    Spacer()
                }
                
                Text(alertContentModelData.alertContent.subject)
                    .font(.iranSans(.bold, size: 15))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                
                Text(alertContentModelData.alertContent.description)
                    .font(.iranSans(.medium, size: 14))
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.trailing)
            }
            .padding()

            HStack(spacing: 0) {
                // Yes event
                CustomButton(title: OK_, buttonTapped: yesButton)
                    .background(Color.AlfaBlue)
                    .foregroundColor(Color.white)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(DEFAULT_RADIUS_16)
        .padding()
        .padding()
        .cornerRadius(DEFAULT_RADIUS_02)
    }
}

/// This class `WarningContentView_Previews` is used to manage specific logic in the application.
struct WarningContentView_Previews: PreviewProvider {
    static var previews: some View {
        WarningContentView(alertContentModelData: AlertContentModelData(alertContent: AlertContent(title: .none, subject: "", description: "You can override this method to perform additional tasks associated with presenting the view. If you override this method, you must call super at some point in your implementation.")), yesButton: {})
            .preferredColorScheme(.light)
    }
}
