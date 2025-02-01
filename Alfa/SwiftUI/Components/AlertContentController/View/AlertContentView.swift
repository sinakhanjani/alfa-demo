//
//  AlertContentView.swift
//  TEST
//
//  Created by Sina khanjani on 12/9/1399 AP.
//

import SwiftUI

/// This class `AlertContentView` is used to manage specific logic in the application.
struct AlertContentView: View {
    
    @ObservedObject var alertContentModelData: AlertContentModelData = AlertContentModelData(alertContent: AlertContent(title: .none, subject: "", description: ""))
    
/// This variable `yesButton` is used to store a specific value in the application.
    var yesButton: onTappedHandler!
/// This variable `noButton` is used to store a specific value in the application.
    var noButton: onTappedHandler!

/// This variable `yesTitle` is used to store a specific value in the application.
    var yesTitle: String = "بله"
/// This variable `noTitle` is used to store a specific value in the application.
    var noTitle: String = "خیر"

/// This variable `body` is used to store a specific value in the application.
    var body: some View {
        VStack {
            VStack(alignment: .trailing, spacing: DEFAULT_PADDING_08) {
                HStack {
                    VStack(alignment: .trailing) {
                        Text(alertContentModelData.alertContent.title.value)
                            .font(.iranSans(.bold, size: 17))
                            .bold()
                            .multilineTextAlignment(.trailing)
                        
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
                // Cancel event
                CustomButton(title: noTitle, buttonTapped: noButton)
                    .background(Color.secondary)
                    .foregroundColor(Color.primary)
                
                // Yes event
                CustomButton(title: yesTitle, buttonTapped: yesButton)
                    .background(Color.AlfaBlue)
                    .foregroundColor(Color.white)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(DEFAULT_RADIUS_02)
        .padding()
        .padding()
        .shadow(radius: 2)
    }
}

/// This class `AlertContentView_Previews` is used to manage specific logic in the application.
struct AlertContentView_Previews: PreviewProvider {
    static var previews: some View {
        AlertContentView(alertContentModelData: AlertContentModelData(alertContent: AlertContent(title: .cancel, subject: "Are you sure to cancel this service?", description: "You can override this method to perform additional tasks associated with presenting the view. If you override this method, you must call super at some point in your implementation.")), yesButton: {}, noButton: {})
            .preferredColorScheme(.dark)
    }
}
