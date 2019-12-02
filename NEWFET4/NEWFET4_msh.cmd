Title "Untitled"

Controls {
}

Definitions {
	Constant "constant_channel_doping" {
		Species = "BoronActiveConcentration"
		Value = 3e+18
	}
	Constant "constant_drain_ext_doping" {
		Species = "PhosphorusActiveConcentration"
		Value = 5e+19
	}
	Constant "constant_drain_doping" {
		Species = "PhosphorusActiveConcentration"
		Value = 5e+19
	}
	Constant "constant_source_ext_doping" {
		Species = "PhosphorusActiveConcentration"
		Value = 5e+19
	}
	Constant "constant_source_doping" {
		Species = "PhosphorusActiveConcentration"
		Value = 5e+19
	}
	Constant "constant_body_doping" {
		Species = "BoronActiveConcentration"
		Value = 3e+18
	}
	Constant "constant_LDD_doping" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+18
	}
	Constant "constant_halo_doping" {
		Species = "BoronActiveConcentration"
		Value = 5e+19
	}
	Refinement "RefinementDefinition_1" {
		MaxElementSize = ( 0.002 0.005 )
		MinElementSize = ( 0.001 0.002 )
	}
	Multibox "MultiboxDefinition_1"
 {
		MaxElementSize = ( 0.05 0.03 )
		MinElementSize = ( 0.03 0.0002 )
		Ratio = ( 1 1.35 )
	}
}

Placements {
	Constant "constant_channel_doping_placement" {
		Reference = "constant_channel_doping"
		EvaluateWindow {
			Element = region ["channel"]
		}
	}
	Constant "constant_source_n_ext_2_doping_placement" {
		Reference = "constant_channel_doping"
		EvaluateWindow {
			Element = region ["source_n_ext_2"]
		}
	}
	Constant "constant_drain_n_ext_2_doping_placement" {
		Reference = "constant_channel_doping"
		EvaluateWindow {
			Element = region ["drain_n_ext_2"]
		}
	}
	Constant "constant_drain_ext_doping_placement" {
		Reference = "constant_drain_ext_doping"
		EvaluateWindow {
			Element = region ["drain_n_ext"]
		}
	}
	Constant "constant_drain_doping_placement" {
		Reference = "constant_drain_doping"
		EvaluateWindow {
			Element = region ["drain_n"]
		}
	}
	Constant "constant_source_ext_doping_placement" {
		Reference = "constant_source_ext_doping"
		EvaluateWindow {
			Element = region ["source_n_ext"]
		}
	}
	Constant "constant_source_doping_placement" {
		Reference = "constant_source_doping"
		EvaluateWindow {
			Element = region ["source_n"]
		}
	}
	Constant "constant_body_doping_placement" {
		Reference = "constant_body_doping"
		EvaluateWindow {
			Element = region ["body"]
		}
	}
	Constant "constant_source_LDD_doping_placement" {
		Reference = "constant_LDD_doping"
		EvaluateWindow {
			Element = region ["source_LDD"]
		}
	}
	Constant "constant_drain_LDD_doping_placement" {
		Reference = "constant_LDD_doping"
		EvaluateWindow {
			Element = region ["drain_LDD"]
		}
	}
	Constant "constant_source_halo_doping_placement" {
		Reference = "constant_halo_doping"
		EvaluateWindow {
			Element = region ["source_halo"]
		}
	}
	Constant "constant_drain_halo_doping_placement" {
		Reference = "constant_halo_doping"
		EvaluateWindow {
			Element = region ["drain_halo"]
		}
	}
	Refinement "RefinementPlacement_1" {
		Reference = "RefinementDefinition_1"
		RefineWindow = Rectangle [(-0.07 0) (0.105 -0.05)]
	}
	Refinement "RefinementPlacement_3" {
		Reference = "RefinementDefinition_1"
		RefineWindow = region ["channel"]
	}
	Multibox "MultiboxPlacement_1" {
		Reference = "MultiboxDefinition_1"
		RefineWindow = Rectangle [(-0.07 0) (0.105 0.6)]
	}
}

