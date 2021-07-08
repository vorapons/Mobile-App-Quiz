//
//  ContentView.swift
//  AppQuiz
//
//  Created by Vorapon Sirimahatham on 5/7/21.
//

import SwiftUI
import SDWebImageSwiftUI

let yExtension: CGFloat = 0

struct ContentView: View {
    
    @ObservedObject var mainVM : MainViewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Product")
                        .bold()
                
                    Spacer()
                    Menu {
                        Button("Sort A-Z", action: {})
                        Button("Sort Z-A", action: {})
                        Button("Sort Created Date", action: {})
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .padding()
                            .font(.headline)
                    }
                }
                .padding(.leading, 40)
                GeometryReader { gp in
                    ScrollView(.vertical) {
                        VStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach ( 0..<20 ) { i in
//                                        Image("000\(i%6)")
                                        if( !mainVM.productStore.products.isEmpty  ) {
                                            Image( uiImage: (((mainVM.productStore.products[0].thumbnailImage != nil) ? mainVM.productStore.products[0].thumbnailImage! : mainVM.productStore.products[0].placeHolder)! ))
                                                .resizable()
                                                .frame(width: 317 , height: 146)
                                                .cornerRadius(5)
                                        }
                                        else
                                        {
                                            Image( systemName: "icloud.and.arrow.down")
                                                .resizable()
                                                .frame(width: 317 , height: 146)
                                                .cornerRadius(5)
                                        }
                                    }
                                }
                            }.padding(.leading , 10)
                            .padding(.bottom , 10)
                            TabView {
                                ForEach( 0..<7 ){ i in
                                    ScrollInPages(mainVM: mainVM)
                                }
                            }
                            .frame(width: gp.size.width, height: gp.size.height + yExtension)
                            .tabViewStyle(PageTabViewStyle())
                        }
                        
                    }
                    // Bug fix for TabView EdgeIgnore not working
                    .offset(y: -yExtension)
                }
            }
            .navigationBarTitle("Production")
            .navigationBarHidden(true)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            mainVM.setProductStoreDataFromJson(jsonData: listJson.data(using: .utf8) )
            for i in 0..<5 {
                mainVM.loadImage(productId: i)
            }
            print(mainVM.productStore.products[1])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                // Deley on Appear
            }
        })
    }
    
    // Not Use delete soon
    func setupAppearance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().backgroundColor = .clear
        
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : UIColor.red,
             NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50, weight: .heavy)]
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "chevron.left.2")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.left.2")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
//        ProductDetailView()
        TestImageView()
    }
}

struct ScrollInPages: View {
    
    @ObservedObject var mainVM : MainViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach ( 0..<10 ) { i in
                    NavigationLink( destination: ProductDetailView2( product : $mainVM.productStore.products[i] ) ) {
                        ProductRow2(product: $mainVM.productStore.products[i] )
                    }
                }
            }
        }
        
    }
}

struct ProductRow : View {
    
    var title : String = "Handmade Soft Cheese"
    var description : String = "The Nagasaki Lander is the trademarked name of several series of Nagasaki sport bikes, that started with the 1984 ABC800J"
    var createdDate : String = "วันที่สร้าง 9 ก.ค. 63 / 22.56น."
    var thumbnailImage : UIImage = UIImage(named: "0000")!
    
    init( product : Product ) {
        
        title = product.title
        description = product.description
        let dateFormatter = DateFormatter()
        createdDate = dateFormatter.string(from: product.createdAt)
        guard product.thumbnailImage != nil else {
            guard let placeHolder =  UIImage(named: "0000") else {
                return
            }
            thumbnailImage = placeHolder
            return
        }
        thumbnailImage = product.thumbnailImage!
    }
    
    init() {
        
    }
    
    var body: some View {
        ZStack {
            GeometryReader { gp in
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.clear)
                    .frame(width: gp.size.width, height: gp.size.height, alignment: .center)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.gray) )
                HStack{
//                    Image("000\( Int.random(in:0..<6) )")
                    Image(uiImage:thumbnailImage)
                        .resizable()
                        .frame(width: 100, height: gp.size.height, alignment: .center)
                        .cornerRadius(5)
                    VStack (alignment: .leading, spacing: 5) {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom,5)
                        Text(description)
                            .font(.footnote)
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .frame(height: 90 )
                        Spacer()
                        Text(createdDate)
                            .font(.footnote)
                    }.padding(5)
                }
            }
        }.frame(width: 350, height: 170, alignment: .center)
    }
    
}

struct ProductRow2 : View {
    
    @Binding var product : Product
 
    let dateFormatter = DateFormatter()
    var body: some View {
        
        ZStack {
            GeometryReader { gp in
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundColor(.clear)
                    .frame(width: gp.size.width, height: gp.size.height, alignment: .center)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.gray) )
                HStack{
//                    Image("000\( Int.random(in:0..<6) )")
                    Image( uiImage: ((product.thumbnailImage != nil) ? product.thumbnailImage! : product.placeHolder)!)
                        .resizable()
                        .frame(width: 100, height: gp.size.height, alignment: .center)
                        .cornerRadius(5)
                    VStack (alignment: .leading, spacing: 5) {
                        Text(product.title)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom,5)
                        Text(product.description)
                            .font(.footnote)
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .frame(height: 90 )
                        Spacer()
                        Text(dateFormatter.string(from: product.createdAt) )
                            .font(.footnote)
                    }.padding(5)
                }
            }
        }.frame(width: 350, height: 170, alignment: .center)
    }
    
}

struct TestImageView : View {
    let url : String = "https://picsum.photos/2048"
    var body: some View {
        ScrollView {
            VStack (spacing : 20 ){
                WebImage(url: URL(string: url)!)
                        .resizable()
                    .frame(width: 400, height: 400, alignment: .center)
                WebImage(url: URL(string: url)!)
                        .resizable()
                    .frame(width: 400, height: 400, alignment: .center)
                WebImage(url: URL(string: url)!)
                        .resizable()
                    .frame(width: 400, height: 400, alignment: .center)
                WebImage(url: URL(string: url)!)
                        .resizable()
                    .frame(width: 400, height: 400, alignment: .center)
                WebImage(url: URL(string: url)!)
                        .resizable()
                    .frame(width: 400, height: 400, alignment: .center)
            }
        }
    }
}

struct ProductDetailView2 : View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var product : Product
    
    var body : some View {
    
        GeometryReader { gp in
            VStack(spacing : 0 ) {
                ZStack {
                    Rectangle()
                        .frame(width: gp.size.width, height: 70)
                        .foregroundColor(.white)
                    HStack(alignment: .center, spacing: 0){
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                        })
                        Text(product.title)
                            .font(.title3)
                            .bold()
                            .frame(width : 270)
                            .frame(maxWidth: .infinity)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    .frame(width: gp.size.width)
                }
                .padding(.top,20)
                .frame(width: gp.size.width, alignment: .center)
                Image( uiImage: ((product.thumbnailImage != nil) ? product.thumbnailImage! : product.placeHolder)!)
                    .resizable()
                    .frame(width: gp.size.width, height: 250)
                    .padding(.bottom,10)
                
                VStack (alignment: .leading, spacing: 15) {
                    Text(product.description)
                    Text("สัด")
                }
                .padding(10)
                Spacer()
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
//        .navigationBarItems(leading:
//                                Button(action: {
//                                    self.presentationMode.wrappedValue.dismiss()
//                                }, label: {
//                                    Image(systemName: "arrow.backward")
//                                        .font(.system(size: 25, weight: .bold, design: .rounded))
//                                        .foregroundColor(.black)
//                                })
//        )
        
    }
}


struct ProductDetailView : View {
    
    var title : String = "Handmade Soft Cheese"
    var description : String = "The Nagasaki Lander is the trademarked name of several series of Nagasaki sport bikes, that started with the 1984 ABC800J"
    var createdDate : String = "วันที่สร้าง 9 ก.ค. 63 / 22.56 น."
    
    @Environment(\.presentationMode) var presentationMode
    
    init( product : Product ) {
        title = product.title
        description = product.description
        let dateFormatter = DateFormatter()
        createdDate = dateFormatter.string(from: product.createdAt) // Fix Problem here it doesn't show on UI (Insert format)?
    }
    
    init() {
        
    }
    
    var body : some View {
    
        GeometryReader { gp in
            VStack(spacing : 0 ) {
                ZStack {
                    Rectangle()
                        .frame(width: gp.size.width, height: 70)
                        .foregroundColor(.white)
                    HStack(alignment: .center, spacing: 0){
                        Button(action: {
                            print("TEST")
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                        })
                        Text(title)
                            .font(.title3)
                            .bold()
                            .frame(width : 270)
                            .frame(maxWidth: .infinity)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    .frame(width: gp.size.width)
                }
                .padding(.top,20)
                .frame(width: gp.size.width, alignment: .center)
                Image("0003")
                    .resizable()
                    .frame(width: gp.size.width, height: 250)
                    .padding(.bottom,10)
                
                VStack (alignment: .leading, spacing: 15) {
                    Text(description)
                        .onTapGesture {
                            print(description)
                        }
                    Text(createdDate)
                }
                .padding(10)
                Spacer()
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
//        .navigationBarItems(leading:
//                                Button(action: {
//                                    self.presentationMode.wrappedValue.dismiss()
//                                }, label: {
//                                    Image(systemName: "arrow.backward")
//                                        .font(.system(size: 25, weight: .bold, design: .rounded))
//                                        .foregroundColor(.black)
//                                })
//        )
        
    }
}


