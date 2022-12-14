// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Case from "./Case.bs.js";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";

function Grid(Props) {
  var data = Props.data;
  var onToggle = Props.onToggle;
  var renderTile = React.useCallback((function (y) {
          return function (x, cellState) {
            var key = "" + x + "-" + y;
            return React.createElement(Case.make, {
                        cell: cellState,
                        onToggle: (function (isFlag) {
                            Curry._2(onToggle, cellState, isFlag);
                          }),
                        key: key
                      });
          };
        }), []);
  var renderRow = React.useCallback((function (y) {
          return function (row) {
            return React.createElement("div", {
                        key: String(y),
                        className: "flex"
                      }, Belt_Array.mapWithIndex(row, Curry._1(renderTile, y)));
          };
        }), []);
  return React.createElement("div", {
              className: "flex flex-col mx-auto"
            }, Belt_Array.mapWithIndex(data, renderRow));
}

var R;

var A;

var make = Grid;

export {
  R ,
  A ,
  make ,
}
/* Case Not a pure module */
