//
//  Data.swift
//  FCUMAP
//
//  Created by RTC18 on 2016/12/9.
//  Copyright © 2016年 AhKui-D0562215. All rights reserved.
//

import Foundation
class Vertex {
    var key: String?
    var lat: Double?
    var long: Double?
    var name: String?
    var edge:Array<Edge>?
    init(key:String,name:String,lat:Double,long:Double,next:Array<String>) {
        self.key = key
        self.lat = lat + 0.000032
        self.long = long - 0.000032
        self.name = name
        self.edge = [Edge]()
        for point in next {
            self.edge!.append(Edge(key:point))
        }
        
    }
}

class Edge{
    var end: String?
    var cost: Double?
    init(key:String ) {
        self.end = key
    }
}
class pointInfo{
    var key:String?
    var name:String?
    init(key:String,name:String) {
        self.key = key
        self.name = name
    }
}
class Dijkstra{
    var points = [String:Vertex]()
    var searchList = [pointInfo]()
    init() {
        let addListQueue = DispatchQueue(label: "add point to list", qos: DispatchQoS.userInitiated)
        addListQueue.async {
            self.add(key: "qiu1",name:"丘逢甲紀念館側一",lat:24.178305,long:120.647944,next:["p55"])
            self.add(key: "qiu2",name:"丘逢甲紀念館側二",lat:24.178315,long:120.648576,next:["p16","p17"])
            self.add(key: "qiu",name:"丘逢甲紀念館大門",lat:24.178444,long:120.648249,next:["p18","p19"])
            self.add(key: "ren1",name:"人言大樓側一",lat:24.179636,long:120.648502,next:["p20","p7","p3"])
            self.add(key: "ren2",name:"人言大樓側二",lat:24.179631,long:120.64874,next:["p21","p4","p3"])
            self.add(key: "renqi",name:"人言大樓啟堰廳",lat:24.179267,long:120.648419,next:["p7","p11","gong2"])
            self.add(key: "ren",name:"人言大樓大門",lat:24.179619,long:120.648607,next:["p3"])
            self.add(key: "ti",name:"体育馆主要路口",lat:24.181498,long:120.649048,next:["yundongchang","p1","p22"])
            self.add(key: "chuang",name:"创客中心",lat:24.179714,long:120.649153,next:["p23","p21"])
            self.add(key: "shang1",name:"商學大樓側一",lat:24.178423,long:120.650045,next:["out_dong","p14"])
            self.add(key: "shang2",name:"商學大樓側二",lat:24.178421,long:120.649491,next:["out_dong","p14","p26","ke1"])
            self.add(key: "library",name:"圖書館大門",lat:24.178707,long:120.648595,next:["p24"])
            self.add(key: "tumu",name:"土木水利館大門",lat:24.181233,long:120.647038,next:["p25","p28"])
            self.add(key: "xuesi1",name:"学思楼側一",lat:24.181622,long:120.646785,next:["xuesi3","xuesi2","p28"])
            self.add(key: "xuesi2",name:"学思楼側二",lat:24.181368,long:120.646603,next:["p25","xuesi1","xuesi"])
            self.add(key: "xuesi",name:"学思楼大门",lat:24.181501,long:120.646807,next:["xuesi3","xuesi2","p28"])
            self.add(key: "out_bei",name:"學園出口（北門）",lat:24.181906,long:120.648203,next:["p22","p27"])
            self.add(key: "xuesi3",name:"学思楼側三",lat:24.181774,long:120.646641,next:["xuesi1","out_mos1","xuesi","p27"])
            self.add(key: "out_dong",name:"學園出口（東門）",lat:24.17852,long:120.650268,next:["p5","p14","shang2","shang1"])
            self.add(key: "p2",name:"路口",lat:24.179361,long:120.64862,next:["p3","p4","p6","p7"])
            self.add(key: "out_youju",name:"學園出口（郵局）",lat:24.178115,long:120.646629,next:["p8"])
            self.add(key: "gong1",name:"工學院側一",lat:24.179188,long:120.647448,next:["p9","p10"])
            self.add(key: "gong2",name:"工學院側二",lat:24.179205,long:120.648185,next:["p7","p11","renqi"])
            self.add(key: "gong",name:"工學院大門",lat:24.179106,long:120.647908,next:["p12"])
            self.add(key: "jian",name:"建築館正門",lat:24.179566,long:120.646644,next:["p13","yuwen1","jian1"])
            self.add(key: "zhong1",name:"忠勤樓側一",lat:24.179217,long:120.646626,next:["p13"])
            self.add(key: "zhong2",name:"忠勤樓側二",lat:24.179222,long:120.647263,next:["p10","p9"])
            self.add(key: "zhong",name:"忠勤樓大門",lat:24.17906,long:120.646931,next:["zhong_back","p10","p29","zhong3"])
            self.add(key: "zhong_under",name:"忠勤樓底樓",lat:24.179423,long:120.647255,next:["p9","p10"])
            self.add(key: "zhong_back",name:"忠勤樓後一",lat:24.17943,long:120.646945,next:["jian1","yuwen2","yuwen3","p9","zhong"])
            self.add(key: "li",name:"理學大樓大门",lat:24.18118,long:120.647412,next:["p28"])
            self.add(key: "ke1",name:"科行館側一",lat:24.178337,long:120.649343,next:["p31","shang2","p26"])
            self.add(key: "ke2",name:"科行館側二",lat:24.178315,long:120.648748,next:["p16","p17"])
            self.add(key: "yule_right",name:"育樂館側(右)",lat:24.180401,long:120.647148,next:["p32","p33"])
            self.add(key: "yule_left",name:"育樂館側(左)",lat:24.180394,long:120.64661,next:["p34","p35"])
            self.add(key: "yule",name:"育樂館大門",lat:24.180011,long:120.646897,next:["p35","p33"])
            self.add(key: "xingone1",name:"行政一館側門",lat:24.178593,long:120.647299,next:["p30","p36"])
            self.add(key: "xingone",name:"行政一館大門",lat:24.178679,long:120.646988,next:["p30","p37"])
            self.add(key: "xingone_back",name:"行政一館後門",lat:24.178477,long:120.647018,next:["p38","p36"])
            self.add(key: "xingtwo1",name:"行政二館側一",lat:24.17859,long:120.647439,next:["p30","p36"])
            self.add(key: "xingtwo2",name:"行政二館側二",lat:24.17857,long:120.647873,next:["p19","p39"])
            self.add(key: "xingtwo",name:"行政二館大門",lat:24.178692,long:120.647628,next:["p30","p39"])
            self.add(key: "yuwen1",name:"語文一",lat:24.179623,long:120.646797,next:["yuwen4","jian1","jian"])
            self.add(key: "yuwen2",name:"語文二",lat:24.179625,long:120.646956,next:["yuwen5","p9","zhong_back","jian1"])
            self.add(key: "zidian1",name:"資訊電機館側門",lat:24.179368,long:120.649039,next:["p4","p21","p40"])
            self.add(key: "zidian",name:"資訊電機館大門",lat:24.179147,long:120.649544,next:["p5","p41"])
            self.add(key: "zidian_back",name:"資訊電機館後門",lat:24.179353,long:120.649544,next:["p23","p21","dianzi"])
            self.add(key: "p27",name:"路口",lat:24.18183,long:120.647252,next:["out_mos1","xuesi3","p28","out_bei"])
            self.add(key: "xuesiyuan",name:"學思園",lat:24.181559,long:120.647583,next:["p28","p22"])
            self.add(key: "p28",name:"路口",lat:24.18131,long:120.647251,next:["p27","xuesiyuan","p22","li","p32","tumu","p25","xuesi","xuesi1"])
            self.add(key: "p22",name:"路口",lat:24.181374,long:120.648171,next:["out_bei","ti","p1","xuesiyuan","p28"])
            self.add(key: "p32",name:"路口",lat:24.180743,long:120.647279,next:["p33","yule_right","p34","p1","p28"])
            self.add(key: "p34",name:"路口",lat:24.180711,long:120.646593,next:["p32","yule_left","p35","p25"])
            self.add(key: "p42",name:"路口",lat:24.17997,long:120.650103,next:["p23","dianzi_back","p54"])
            self.add(key: "p46",name:"路口",lat:24.17995,long:120.648996,next:["yundongchang","p54","p21","p48"])
            self.add(key: "p48",name:"路口",lat:24.179954,long:120.648267,next:["p47","p33","p1","p46"])
            self.add(key: "p33",name:"路口",lat:24.179924,long:120.647327,next:["p48","p9","yuwen5","yuwen6","p35","yule_right","p32","yule"])
            self.add(key: "p35",name:"路口",lat:24.179912,long:120.646571,next:["p34","yule_left","yule","p33","yuwen4","yuwen5","p13"])
            self.add(key: "p23",name:"路口",lat:24.179735,long:120.650115,next:["p42","p5","zidian_back","dianzi","chuang","p21"])
            self.add(key: "p47",name:"路口",lat:24.17963,long:120.648279,next:["p20","p48","p9"])
            self.add(key: "p9",name:"路口",lat:24.179598,long:120.647341,next:["p47","gong1","p10","zhong2","zhong_under","zhong_back","jian1","yuwen2","yuwen3","p33"])
            self.add(key: "p21",name:"路口",lat:24.179584,long:120.648975,next:["p46","chuang","dianzi","p23","zidian_back","zidian1","p4","p3","ren2","p40"])
            self.add(key: "p3",name:"路口",lat:24.179542,long:120.648619,next:["ren","ren2","p21","p4","p2","p7","p20","ren1"])
            self.add(key: "p7",name:"路口",lat:24.179352,long:120.648316,next:["p20","ren1","p3","p2","renqi","p11","gong2"])
            self.add(key: "p4",name:"路口",lat:24.17937,long:120.648925,next:["p21","zidian1","p40","p2","p3","ren2"])
            self.add(key: "p5",name:"路口",lat:24.179037,long:120.650137,next:["out_dong","zidian","p41","p23"])
            self.add(key: "p6",name:"路口",lat:24.179012,long:120.64864,next:["p2","p40","p24","p11"])
            self.add(key: "p40",name:"路口",lat:24.179017,long:120.649024,next:["p4","p21","zidian1","p41","p6"])
            self.add(key: "p11",name:"路口",lat:24.179008,long:120.64831,next:["p6","p24","p51","gong2","p7","renqi"])
            self.add(key: "p41",name:"路口",lat:24.17901,long:120.649311,next:["zidian","p31","p5","p40"])
            self.add(key: "p12",name:"路口",lat:24.179,long:120.647936,next:["gong","p51","p50","p39","p10"])
            self.add(key: "p10",name:"路口",lat:24.178975,long:120.647354,next:["p12","p30","p29","zhong","zhong2","zhong_under","p9","gong1"])
            self.add(key: "p39",name:"路口",lat:24.178738,long:120.647941,next:["p12","p51","p50","p19","xingtwo2","xingtwo","p30"])
            self.add(key: "p30",name:"路口",lat:24.17874,long:120.64737,next:["p10","p39","xingtwo","xingtwo1","p36","xingone1","xingone","p37"])
            self.add(key: "p19",name:"路口",lat:24.178544,long:120.647928,next:["p39","qiu","p55","xingtwo2"])
            self.add(key: "p43",name:"路口",lat:24.178469,long:120.648546,next:["p49","p16","p18"])
            self.add(key: "p14",name:"路口",lat:24.178446,long:120.649409,next:["shang2","p26","p31","shang1","out_dong"])
            self.add(key: "p38",name:"路口",lat:24.178423,long:120.646651,next:["p37","xingone_back","p36","p8"])
            self.add(key: "p36",name:"路口",lat:24.178445,long:120.647355,next:["p44","p38","xingone_back","xingone1","p30","xingtwo1"])
            self.add(key: "p16",name:"路口",lat:24.178347,long:120.64865,next:["p43","qiu2","p17","ke2","p31"])
            self.add(key: "p8",name:"路口",lat:24.178215,long:120.646668,next:["p38","youju","p44","out_youju"])
            self.add(key: "p44",name:"路口",lat:24.178245,long:120.647362,next:["p8","youju","p36","p15"])
            self.add(key: "p45",name:"路口",lat:24.178125,long:120.647904,next:["p17","p15"])
            self.add(key: "p26",name:"路口",lat:24.178173,long:120.649425,next:["p17","ke1","p14","shang2"])
            self.add(key: "p17",name:"路口",lat:24.178144,long:120.648649,next:["p26","p45","ke2","p16","qiu2"])
            self.add(key: "youju",name:"郵局",lat:24.17815,long:120.64688,next:["p8","p44"])
            self.add(key: "dianzi",name:"電子通訊館大門",lat:24.179759,long:120.649528,next:["p23","p21","zidian_back"])
            self.add(key: "dianzi_back",name:"電子通訊館後門",lat:24.179922,long:120.649506,next:["p54","p42"])
            self.add(key: "p29",name:"路口",lat:24.178926,long:120.646643,next:["p13","zhong3","zhong","p10","p37"])
            self.add(key: "out_mos",name:"摩斯門正門",lat:24.181303,long:120.646474,next:["p25"])
            self.add(key: "out_mos1",name:"摩斯門側門",lat:24.181806,long:120.646477,next:["xuesi3","p27"])
            self.add(key: "zhong3",name:"忠勤樓側三",lat:24.179069,long:120.646667,next:["p29","zhong"])
            self.add(key: "p37",name:"路口",lat:24.178729,long:120.646647,next:["p29","p30","xingone","p38"])
            self.add(key: "p13",name:"路口",lat:24.179568,long:120.646575,next:["p35","jian","zhong1","p29"])
            self.add(key: "p25",name:"路口",lat:24.181304,long:120.646502,next:["p28","tumu","p34","xuesi2","out_mos"])
            self.add(key: "p31",name:"路口",lat:24.178452,long:120.649313,next:["p41","p14","ke1","p16"])
            self.add(key: "p18",name:"路口",lat:24.178519,long:120.648244,next:["p52","p43","qiu"])
            self.add(key: "p53",name:"路口",lat:24.178605,long:120.648468,next:["p49","p24"])
            self.add(key: "p49",name:"路口",lat:24.17853,long:120.648586,next:["p53","p43"])
            self.add(key: "p50",name:"路口",lat:24.178697,long:120.648065,next:["p51","p52","p39","p12"])
            self.add(key: "p51",name:"路口",lat:24.179003,long:120.648051,next:["p50","p39","p12","p11"])
            self.add(key: "p52",name:"路口",lat:24.178643,long:120.648258,next:["p50","p18","p24"])
            self.add(key: "p24",name:"路口",lat:24.178699,long:120.648459,next:["p11","p6","library","p53","p52"])
            self.add(key: "p15",name:"路口",lat:24.17827,long:120.647871,next:["qiu1","p45","p44","p55"])
            self.add(key: "yundongchang",name:"運動場看台",lat:24.180387,long:120.64917,next:["p1","p46","ti","p54"])
            self.add(key: "p54",name:"路口",lat:24.179962,long:120.649249,next:["p46","dianzi_back","p42","yundongchang"])
            self.add(key: "p20",name:"路口",lat:24.179552,long:120.648303,next:["p47","ren1","p3","p7"])
            self.add(key: "p1",name:"路口",lat:24.18077,long:120.648239,next:["p22","ti","yundongchang","p48","p32"])
            self.add(key: "jian1",name:"建築館後門",lat:24.179571,long:120.646787,next:["yuwen1","yuwen2","p9","zhong_back","jian"])
            self.add(key: "yuwen3",name:"語文三",lat:24.179642,long:120.647165,next:["yuwen6","p9","zhong_back"])
            self.add(key: "yuwen4",name:"語文四",lat:24.179859,long:120.646783,next:["p35","yuwen1"])
            self.add(key: "yuwen5",name:"語文五",lat:24.179869,long:120.64696,next:["p35","yuwen2","p33"])
            self.add(key: "yuwen6",name:"語文六",lat:24.179874,long:120.647143,next:["p33","yuwen3"])
            self.add(key: "p55",name:"路口",lat:24.17834,long:120.647884,next:["p15","qiu1","p19"])
            self.extraadd(key: "out_main", name: "路口", lat: 24.178828, long: 120.646460, next: ["p37","p38"])
            self.count()
            self.searchList.sort(by: { (s1, s2) -> Bool in
                return s1.key! < s2.key!
            })
            

        }
        
    }
    func extraadd(key:String,name:String,lat:Double,long:Double,next:Array<String>){
        points[key] = Vertex(key: key, name: name, lat: lat, long: long, next: next)
        for p in next {
            points[p]?.edge?.append(Edge(key: key))
        }
    }
    func add(key:String,name:String,lat:Double,long:Double,next:Array<String>){
        points[key] = Vertex(key: key, name: name, lat: lat, long: long, next: next)
        if name != "路口" {
            searchList.append( pointInfo(key: key, name: name) )
        }
    }
    func count(){
        for (_,point) in points{
            for _edge in point.edge! {
                _edge.cost = countRange(a: point, b: (points[(_edge.end!)])!)
            }
            
        }
    }
    func countRange(a:Vertex,b:Vertex) -> Double{
        let lat = abs((a.lat! * 1000000)-( (b.lat)!*1000000 ))
        let long = abs((a.long! * 1000000)-( (b.long)!*1000000 ))
        return sqrt(lat*lat + long*long)
    }
    func countSize(a:Vertex,b:Vertex,c:Vertex) -> Double{
        let ab = countRange(a: a, b: b)
        let ac = countRange(a: a, b: c)
        let bc = countRange(a: b, b: c)
        let s = 0.5*(ab+ac+bc)
        return sqrt(s*(s-ab)*(s-ac)*(s-bc))
    }
    func isInMap() -> Bool {
        let a = Vertex(key: "", name: "", lat: 24.181895, long: 120.646352, next: [])
        let b = Vertex(key: "", name: "", lat: 24.178026, long: 120.646586, next: [])
        let c = Vertex(key: "", name: "", lat: 24.178167, long: 120.650248, next: [])
        let d = Vertex(key: "", name: "", lat: 24.181927, long: 120.650172, next: [])
        let e = points["current"]!
        let mapsize = countSize(a: a, b: b, c: c) + countSize(a: a, b: d, c: c)
        let pointinmap = countSize(a: e, b: a, c: b) + countSize(a: e, b: b, c: c) + countSize(a: e, b: c, c: d) + countSize(a: e, b: d, c: a)
        if Int(pointinmap) <= Int(mapsize){
            return true
        } else {
            return false
        }
    }
    func proccess(start:String,end:String) -> Array<String> {
        var dist = [String:Double]()
        var prev = [String:String]()
        var pointlist = [String]()
        var pathlist = 	[String:[Edge]]()
        for (point_index,point) in points{
            dist[point_index] = Double(Int.max)
            prev[point_index] = nil
            pointlist.append(point_index)
            pathlist[point_index] = point.edge!
        }
        if pointlist.filter({(aa)->Bool in
            if aa==start || aa==end {
                return true
            }
            return false
        }).count == 2 {
            dist[start] = 0.0
            var u = ""
            while pointlist.count > 0 {
                var min = Double(Int.max)
                var pointlistIndex = 0
                for (index,key) in pointlist.enumerated() {
                    if dist[key]! < min {
                        min = dist[key]!
                        u = key
                        pointlistIndex = index
                    }
                }
                pointlist.remove(at: pointlistIndex)
                if dist[u] == Double(Int.max) || u == end {
                    break
                }
                if let path = pathlist[u] {
                    for _edge in path {
                        let alt = dist[u]! + _edge.cost!
                        if alt < dist[( (_edge.end)! )]! {
                            dist[( (_edge.end)! )] = alt
                            prev[( (_edge.end)! )] = u
                        }
                    }
                }
            }
            var path = [String]()
            u = end
            while let pre = prev[u] {
                path.append(u)
                u = pre
            }
            path.append(u)
            return path.reversed()
        } else {
            return ["Error"]
        }
        
        
        
    }
    func proccessreal(lat:Double,long:Double,end:String) -> Array<String> {
        var allRange = [String:Double]()
        let currentPoint = Vertex(key: "current", name: "currentlocation", lat: lat, long: long, next: [])
        for (index,point) in points{
            allRange[index] = countRange(a: currentPoint, b: point)
        }
        for _ in 0...2 {
            let min = allRange.min(by: { (s1, s2) -> Bool in
                return s1.value < s2.value
            })
            let _edge = Edge(key: (min?.key)!)
            _edge.cost = min?.value
            currentPoint.edge?.append(_edge)
            allRange.removeValue(forKey: (min?.key)!)
        }
        points["current"] = currentPoint
        if isInMap() {
            return proccess(start: "current", end: end)
        } else {
            return ["Error!"]
        }
    }
}
