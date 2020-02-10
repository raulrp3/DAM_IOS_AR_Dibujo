//
//  ViewController.swift
//  DAM_IOS_Dibujo_AR
//
//  Created by raul.ramirez on 10/02/2020.
//  Copyright © 2020 Raul Ramirez. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var mSceneview: ARSCNView!
    @IBOutlet weak var buttonDraw: UIButton!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.mSceneview.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        self.mSceneview.showsStatistics = true
        self.mSceneview.session.run(configuration)
        
        //Declaración de la propia clase como la que va a utilizar el delegate.
        self.mSceneview.delegate = self
    }
    
    //Esta función es llamada por el delegate cada vez que se este renderizando.
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //Dibuja delante de la cámara.
        guard let pointOfView = self.mSceneview.pointOfView else { return }
        let transform = pointOfView.transform //Obtenemos la posición de la cámara.
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let frontOfCamera = orientation + location
        
        DispatchQueue.main.async {
            //Comprobamos si el botón esta presionado.
            if self.buttonDraw.isHighlighted{
                //Si el botón es presionado dibuja.
                let sphere = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                sphere.position = frontOfCamera
                
                self.mSceneview.scene.rootNode.addChildNode(sphere)
            }else{
                //Si el botón no esta presionado, dibujamos un puntero.
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                //Le damos un nombre para diferenciar del dibujo.
                pointer.name = "pointer"
                pointer.position = frontOfCamera
                
                //Eliminamos el puntero ya dibujado.
                self.mSceneview.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer"{
                        node.removeFromParentNode()
                    }
                })
                
                self.mSceneview.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

//Función que suma dos vectores y devuelve su resultado.
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
