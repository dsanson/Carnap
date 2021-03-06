{-# LANGUAGE RankNTypes, FlexibleContexts #-}
module Carnap.Languages.PurePropositional.Logic 
    ( PropSequentCalc
    , parsePropLogic, PropLogic, propCalc
    , parseMontagueSC, MontagueSC, montagueSCCalc
    , parseLogicBookSD, LogicBookSD, logicBookSDCalc
    , parseLogicBookSDPlus,  LogicBookSDPlus, logicBookSDPlusCalc
    , parseHowardSnyderSL, HowardSnyderSL, howardSnyderSLCalc
    , parseIchikawaJenkinsSL, IchikawaJenkinsSL, ichikawaJenkinsSLCalc
    , parseHausmanSL, HausmanSL, hausmanSLCalc
    , parseMagnusSL, MagnusSL, magnusSLCalc
    , parseMagnusSLPlus, MagnusSLPlus, magnusSLPlusCalc
    , parseThomasBolducAndZachTFL, ThomasBolducAndZachTFL, thomasBolducAndZachTFLCalc
    , parseThomasBolducAndZachTFLCore, ThomasBolducAndZachTFLCore, thomasBolducAndZachTFL2019Calc
    , parseEbelsDugganTFL, EbelsDugganTFL, ebelsDugganTFLCalc
    , parseTomassiPL, TomassiPL, tomassiPLCalc
    , parseHardegreeSL, HardegreeSL, hardegreeSLCalc
    , parseGentzenPropNJ, GentzenPropNJ, gentzenPropNJCalc
    , parseGentzenPropNK, GentzenPropNK, gentzenPropNKCalc
    , ofPropSys, ofPropTreeSys
    ) where

import Carnap.Calculi.Util
import Carnap.Calculi.NaturalDeduction.Syntax
import Carnap.Calculi.Tableau.Data
import Carnap.Core.Data.Types
import Carnap.Languages.PurePropositional.Syntax
import Carnap.Languages.PurePropositional.Logic.Rules (PropSequentCalc)
import Carnap.Languages.PurePropositional.Logic.BergmannMoorAndNelson
import Carnap.Languages.PurePropositional.Logic.Carnap
import Carnap.Languages.PurePropositional.Logic.Hardegree
import Carnap.Languages.PurePropositional.Logic.Hausman
import Carnap.Languages.PurePropositional.Logic.Gamut
import Carnap.Languages.PurePropositional.Logic.HowardSnyder
import Carnap.Languages.PurePropositional.Logic.KalishAndMontague
import Carnap.Languages.PurePropositional.Logic.Magnus
import Carnap.Languages.PurePropositional.Logic.ThomasBolducAndZach
import Carnap.Languages.PurePropositional.Logic.EbelsDuggan
import Carnap.Languages.PurePropositional.Logic.Tomassi
import Carnap.Languages.PurePropositional.Logic.IchikawaJenkins
import Carnap.Languages.PurePropositional.Logic.Gentzen
import Carnap.Languages.PurePropositional.Logic.OpenLogic

ofPropSys :: (forall r . (Show r, Inference r PurePropLexicon (Form Bool)) => 
              NaturalDeductionCalc r PurePropLexicon (Form Bool) -> a) -> String -> Maybe a
ofPropSys f sys | sys == "prop"                          = Just $ f propCalc 
                | sys == "montagueSC"                    = Just $ f montagueSCCalc 
                | sys == "LogicBookSD"                   = Just $ f logicBookSDCalc 
                | sys == "LogicBookSDPlus"               = Just $ f logicBookSDPlusCalc 
                | sys == "hausmanSL"                     = Just $ f hausmanSLCalc 
                | sys == "gamutPND"                      = Just $ f gamutPNDCalc
                | sys == "gamutPNDPlus"                  = Just $ f gamutPNDPlusCalc
                | sys == "gamutIPND"                     = Just $ f gamutIPNDCalc
                | sys == "gamutMPND"                     = Just $ f gamutMPNDCalc
                | sys == "howardSnyderSL"                = Just $ f howardSnyderSLCalc 
                | sys == "ichikawaJenkinsSL"             = Just $ f ichikawaJenkinsSLCalc
                | sys == "hausmanSL"                     = Just $ f hausmanSLCalc
                | sys == "magnusSL"                      = Just $ f magnusSLCalc 
                | sys == "magnusSLPlus"                  = Just $ f magnusSLPlusCalc 
                | sys == "thomasBolducAndZachTFL"        = Just $ f thomasBolducAndZachTFLCalc 
                | sys == "thomasBolducAndZachTFL2019"    = Just $ f thomasBolducAndZachTFL2019Calc
                | sys == "ebelsDugganTFL"                = Just $ f ebelsDugganTFLCalc 
                | sys == "tomassiPL"                     = Just $ f tomassiPLCalc
                | sys == "hardegreeSL"                   = Just $ f hardegreeSLCalc 
                | otherwise                              = Nothing

ofPropTreeSys :: (forall r . 
                    ( Show r
                    , Inference r PurePropLexicon (Form Bool)
                    , StructuralInference r PurePropLexicon (ProofTree r PurePropLexicon (Form Bool))
                    , StructuralOverride r (ProofTree r PurePropLexicon (Form Bool))
                 ) => 
              TableauCalc PurePropLexicon (Form Bool) r -> a) -> String -> Maybe a
ofPropTreeSys f sys | sys == "propNJ"                     = Just $ f gentzenPropNJCalc 
                    | sys == "propNK"                     = Just $ f gentzenPropNKCalc 
                    | sys == "openLogicNK"                = Just $ f olpPropNKCalc 
                    | otherwise                           = Nothing

