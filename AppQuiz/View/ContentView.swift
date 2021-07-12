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
    
//    @ObservedObject var mainVM : MainViewModel = MainViewModel()
    @ObservedObject var mainVM : MainViewModel
    @State var sortOption : SortOption = .CreateAtAsc
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var placeHolder = UIImage(systemName: "square.and.arrow.down")
    
    var body: some View {
        PreviewCover(condition: mainVM.bannerStore.isAllBannerLoaded){
            NavigationView {
                VStack(spacing : 0 ){
                    VStack( ){
                        HStack ( alignment: .center ){
                            Text("Product")
                                .bold()
                            Spacer()
                            SortingMenu(sortOption: $mainVM.productStore.sortOption)
                        }
                        .padding(.leading , 40 )
                        .padding(.bottom , 0 )
                        Divider()
                            .padding(.bottom,10)
                    }
                    GeometryReader { gp in
                        ScrolinOnPortVonLandStack {
                            VonPortHonLandStack {
                                ScrollView( verticalSizeClass == .compact ? .vertical : .horizontal ) {
                                    HonPortVonLandStack {
                                        ForEach ( mainVM.bannerStore.banners ) { banner in
                                            Image( uiImage: banner.image != nil ? banner.image! : placeHolder! )
                                            .resizable()
                                            .frame(height : 146 )
                                            .frame(maxWidth: verticalSizeClass == .compact ? .infinity : 317)
                                            .cornerRadius(5)
                                        }
                                    }
                                }.padding(.leading , 10)
                                .frame( height : verticalSizeClass == .compact ? gp.size.height : nil )
                                if verticalSizeClass == .compact {
                                    TabView {
                                        ForEach( 0..<mainVM.productStore.numberOfPages ){ i in
//                                        ForEach( 0..<1 ){ i in
                                            ScrollInPagesWithPages(mainVM: mainVM,pageNumber: i)
//                                            ScrollInPages(mainVM: mainVM)
                                        }
                                    }
                                    .frame(width: gp.size.width*3/5 )
                                    .frame( maxHeight : .infinity )
                                    .tabViewStyle(PageTabViewStyle())
                                }
                                else {
                                    TabView {
                                        ForEach( 0..<mainVM.productStore.numberOfPages ){ i in
//                                        ForEach( 0..<1 ){ i in
                                            ScrollInPagesWithPages(mainVM: mainVM,pageNumber: i)
//                                            ScrollInPages(mainVM: mainVM)
                                        }
                                    }
                                    .frame(width: gp.size.width, height: gp.size.height )
                                    .tabViewStyle(PageTabViewStyle())
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Production")
                .navigationBarHidden(true)
            }.phoneOnlyStackNavigationView()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var product = Product(id: 0, coverImage: UIImage(named: "0001"), thumbnailImage: UIImage(named: "0002"), coverImageURL: nil, thumbnailImageURL: nil, coverLoaded: true, thumbnailLoaded: true, title: "Licensed Frozen Chips", description: "Andy shoes are designed to keeping in mind durability as well as trends, the most stylish range of shoes & sandals", createdAt: Date(), createdAtTH: "9/12/1211", placeHolder: nil)
    
    static var previews: some View {
//        ContentView()
//        ProductDetailView2()
//        TestImageView()
        Group{
//            ProductDetailView(product: product)
//            ProductDetailView(product: product)
//                .previewLayout(.fixed(width: 812, height: 375)) // 1
//                .environment(\.verticalSizeClass, .compact) // 3
//                .environment(\.horizontalSizeClass, .compact) // 2
            EmptyView()
        }
       
    }
}

struct ScrollInPages: View {
    
    @ObservedObject var mainVM : MainViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
//                ForEach ( 0..<10 ) { i in
//                List ( 0..<10 , id: \.self) { i in
                ForEach( mainVM.productStore.showLists[0], id : \.self ) { i in
                    // Add selected for Show condition here 
                    if( mainVM.productStore.products[i].imageLoaded && mainVM.productStore.showLists[0].contains(i) ) {
                        NavigationLink( destination: ProductDetailView( product : $mainVM.productStore.products[i] ) ) {
                            ProductRow(product: $mainVM.productStore.products[i] )
                        }.onAppear(){
                            print("On Appear run at \(i)")
                            if( i == mainVM.productStore.showLists[0].count - 3  ) {
                                print("On appear page = \(i) ")
                                mainVM.updateShowListOf(page: 0, showIndex: i)
                                mainVM.loadImageList(productIdList: mainVM.prepareProductForShow())
                            }
                        }
                    }
                }
            }
        }
        
    }
}

struct ScrollInPagesWithPages: View {
    
    @ObservedObject var mainVM : MainViewModel
    var pageNumber : Int
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach( mainVM.productStore.showLists[pageNumber].indices, id : \.self ) { i in
                    if( mainVM.productStore.products[mainVM.productStore.showLists[pageNumber][i]].imageLoaded && mainVM.productStore.showLists[pageNumber].contains(mainVM.productStore.showLists[pageNumber][i]) ) {
                        NavigationLink( destination: ProductDetailView( product : $mainVM.productStore.products[mainVM.productStore.showLists[pageNumber][i]] ) ) {
                            ProductRow(product: $mainVM.productStore.products[mainVM.productStore.showLists[pageNumber][i]] )
                        }.onAppear(){
                            print("OnAppear of Page \(pageNumber):\(i) ShowIndex : \(mainVM.productStore.showLists[pageNumber][i]) ")
                            if( i == mainVM.productStore.showLists[pageNumber].count - 3  ) {
                                print("On appear page = \(i) ")
                                mainVM.updateShowListOf(page: pageNumber, showIndex: i)
                                mainVM.loadImageList(productIdList: mainVM.prepareProductForShow())
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

struct ProductRow : View {
    
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
                HStack(alignment : .top){
                    Image( uiImage: ((product.thumbnailImage != nil) ? product.thumbnailImage! : product.placeHolder)!)
                        .resizable()
                        .frame(width: 100, height: gp.size.height, alignment: .center)
                        .cornerRadius(5)
                    VStack (alignment: .leading, spacing: 5) {
                        Text(product.title)
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(product.description)
                            .font(.footnote)
                            .lineLimit(5)
                            .multilineTextAlignment(.leading)
                            .frame( maxHeight : .infinity,alignment: .top)
//                        Text("\(product.id)")
//                            .font(.footnote)
                        Spacer()
                        Text("วันที่สร้าง " + product.createdAtTH )
                            .font(.footnote)
                            .padding(.bottom,10)
                    }.frame( height: gp.size.height, alignment: .center)
                    .foregroundColor(.black)
                    .padding(5)
                }
            }
        }.frame(width: 350, height: 170, alignment: .center)
    }
}

struct ProductDetailView : View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Binding var product : Product
    var placeHolder = UIImage(systemName: "square.and.arrow.down")
    
    var body : some View {
    
        GeometryReader { gp in
            VStack {
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
                            .frame(width: gp.size.width-100)
                            .frame(maxWidth: .infinity)
                        Spacer()
                            .frame(maxWidth: .infinity)
                    }
                    .frame(width: gp.size.width)
                }
                .padding(.top,20)
                .frame(width: gp.size.width, alignment: .center)
                Divider().padding(.bottom,5)
                if verticalSizeClass == .compact {
                    HStack( alignment : .top ,spacing : 0 ) {
                        
                        Image( uiImage: product.coverImage != nil ? product.coverImage! : placeHolder! )
                            .resizable()
                            .frame(width: gp.size.width/2, height: 250)
                            .padding(.bottom,10)
                            .padding(.leading,10)
                        
                        VStack (alignment: .leading, spacing: 15) {
                            Text(product.description)
                            Text("วันที่สร้าง " + product.createdAtTH)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing,20)
                        Spacer()
                    }
                }
                else {
                    VStack(spacing : 0 ) {
                        if( product.coverImage != nil ) {
                            Image( uiImage: product.coverImage! )
                                    .resizable()
                                    .frame(width: gp.size.width, height: 250)
                                    .padding(.bottom,10)
                        }
                        else {
                            Image( uiImage: placeHolder! )
                                    .resizable()
                                    .frame(width: gp.size.width/2, height: 250)
                                    .padding(.bottom,10)
                                    .padding(.leading,10)
                        }
                                
                            VStack (alignment: .leading, spacing: 15) {
                                Text(product.description)
                                Text("วันที่สร้าง " + product.createdAtTH)
                            }
                            .padding(10)
                            Spacer()
                    }
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}


struct SortingMenu: View {
    @Binding var sortOption : SortOption
    var body: some View {
        Menu(  ) {
            Button(action: {
                print("Sort A-Z")
                sortOption = .AZasc
            }, label: {
                if ( sortOption == .AZasc ){
                    Label("Sort by title A-Z", systemImage: "checkmark.circle")
                }
                else { Text("Sort by title A-Z") }
            })
            Button(action: {
                print("Sort Z-A")
                sortOption = .AZdesc
            }, label: {
                if ( sortOption == .AZdesc ){
                    Label("Sort by title Z-A", systemImage: "checkmark.circle")
                }
                else { Text("Sort by title Z-A") }
            })
            Button(action: {
                print("Create Date Ascending")
                sortOption = .CreateAtAsc
            }, label: {
                if ( sortOption == .CreateAtAsc ){
                    Label("Create Date Ascending", systemImage: "checkmark.circle")
                }
                else { Text("Create Date Ascending") }
            })
            Button(action: {
                print("Sort Created Date Desc")
                sortOption = .CreateAtDesc
            }, label: {
                if ( sortOption == .CreateAtDesc ){
                    Label("Create Date Descending", systemImage: "checkmark.circle")
                }
                else { Text("Create Date Descending") }
            })
            // For Debugging
//            Button(action: {
//                print("Sort by ID")
//                sortOption = .IDAsc
//            }, label: {
//                if ( sortOption == .IDAsc ){
//                    Label("Sort by ID", systemImage: "checkmark.circle")
//                }
//                else { Text("Sort by ID") }
//            })
//            Button(action: {
//                print("Sort by ID Desc")
//                sortOption = .IDDesc
//            }, label: {
//                if ( sortOption == .IDAsc ){
//                    Label("Sort by ID Desc", systemImage: "checkmark.circle")
//                }
//                else { Text("Sort by ID Desc") }
//            })
            
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .padding()
                .font(.headline)
                .foregroundColor(.black)
        }
    }
}


struct VonPortHonLandStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var content: Content

  public init( @ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    if verticalSizeClass == .compact  {
        HStack (alignment : .top) { content }
    }
    else {
        VStack { content }
    }
  }
}

struct HonPortVonLandStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var content: Content

  public init( @ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    if verticalSizeClass == .compact  {
        VStack () { content }
    }
    else {
        HStack { content }
    }
  }
}

struct ScrolinOnPortVonLandStack<Content: View>: View {

    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var content: Content

  public init( @ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    if verticalSizeClass == .compact  {
        VStack () { content }
    }
    else {
        ScrollView(.vertical) { content }
    }
  }
}

struct PreviewCover<Content: View> : View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var content: Content
    var condition : Bool

    public init( condition : Bool ,@ViewBuilder content: () -> Content) {
    self.content = content()
    self.condition = condition
  }

  var body: some View {
    if condition  {
        content
    }
    else {
        
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
            .scaleEffect(3)
    }
  }
}
