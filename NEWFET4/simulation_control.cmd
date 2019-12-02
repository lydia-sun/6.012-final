File {
Grid = "NEWFET4_msh.tdr"
Current = "NEWFET4_def.plt" 
Plot = "NEWFET4_def.tdr" 
Output = "NEWFET4_def.log"
}

Electrode {
{ Name="Drain_contact" Voltage=0.9 } * CHANGE THIS TO SET VDD
{ Name="Source_contact" Voltage=0.0 } 
{ Name="Gate_contact" Voltage=0.0 }
{ Name="Body_contact" Voltage=0.0 }
}

Physics {
Mobility( DopingDep HighFieldSat Enormal )
EffectiveIntrinsicDensity ( OldSlotBoom )
}

Plot {
eDensity hDensity eCurrent hCurrent 
Potential SpaceCharge ElectricField 
eMobility hMobility eVelocity hVelocity 
Doping DonorConcentration AcceptorConcentration
}

Math {Extrapolate 
RelErrControl *on by default 
Iterations=50 
Notdamped=100
}

Solve {
Coupled(Iterations=100){ Poisson }
Coupled{ Poisson Electron Hole }
*-Bias Cathode to target bias 
Quasistationary(InitialStep=0.001 Increment=1.1 
MinStep=1e-5 MaxStep=0.05 
Goal{ Name="Gate_contact" Voltage=0.9 } *CHANGE THIS TO SET VDD
){ Coupled{ Poisson Electron Hole }}
}
