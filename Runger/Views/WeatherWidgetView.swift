import SwiftUI
import Foundation

struct WeatherWidgetView: View {
    // Example data structure for hourly forecast
    struct HourlyForecast {
        var time: String
        var icon: String
        var temperature: String
    }
    
    // Sample data for the hourly forecast
    let hourlyForecasts = [
        HourlyForecast(time: "4PM", icon: "sun.max.fill", temperature: "46°"),
        HourlyForecast(time: "5PM", icon: "sun.max.fill", temperature: "44°"),
        HourlyForecast(time: "6PM", icon: "cloud.sun.fill", temperature: "41°"),
        HourlyForecast(time: "7PM", icon: "sun.max.fill", temperature: "46°"),
        HourlyForecast(time: "8PM", icon: "sun.max.fill", temperature: "44°"),
        HourlyForecast(time: "9PM", icon: "cloud.sun.fill", temperature: "41°")
        // ... Add additional forecasts as needed
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            // Location and Current Temperature
            HStack {
                VStack(alignment: .leading) {
                    Text("San Francisco")
                        .font(.title3)
                       
                    Text("44°")
                        .font(.system(size: 44, weight: .thin))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                }
                Spacer()
                Image(systemName: "sun.max.fill")
                    .renderingMode(.original)
                    .font(.system(size: 30))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 10))
            }
            
            // Hourly Forecast
            HStack(spacing: 1) { // Increase spacing to spread out the views horizontally
                ForEach(hourlyForecasts, id: \.time) { forecast in
                    VStack(spacing: 1) { // Increase spacing to add more vertical space
                        Text(forecast.time)
                            .font(.caption)
                            .opacity(0.6) // Make the time font slightly transparent
                        Image(systemName: forecast.icon)
                            .renderingMode(.original)
                            .font(.title3)
                        Text(forecast.temperature)
                            .font(.caption)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 22)) // Add padding to the scroll view for better edge appearance
               
            }
            .frame(maxWidth: 369, minHeight: 50, alignment: .center)
            
        }
        .padding()
        .frame(maxWidth: 369, minHeight: 50)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .top, endPoint: .bottom))
//        .background(
//            Image("wp2529688") // Replace with your image name
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .clipped()
//        )
        .cornerRadius(20)
        .foregroundColor(.white)
        .shadow(radius: 10)
    }
}

struct WeatherWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetView()
    }
}
