<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProduitController;
use App\Http\Controllers\MouvementController;
// use App\Http\Controllers\AuthController;


Route::get('/', function () {
    return response()->json(['status' => 'Laravel is working!']);
});
Route::apiResource('produits', ProduitController::class);
Route::post('produits/{id}/mouvements', [MouvementController::class, 'store']);
Route::get('produits/{id}/mouvements', [MouvementController::class, 'index']);
// Route::post('/register', [AuthController::class, 'register']);
// Route::post('/login', [AuthController::class, 'login']);

// Route::middleware('auth:sanctum')->group(function () {
//     Route::post('/logout', [AuthController::class, 'logout']);
//     Route::get('/user', fn () => auth()->user());
// });