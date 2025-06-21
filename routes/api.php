<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\ProduitController;
use App\Http\Controllers\MouvementController;
use App\Http\Controllers\AuthController;



Route::apiResource('produits', ProduitController::class);
Route::post('produits/{id}/mouvements', [MouvementController::class, 'store']);
Route::get('produits/{id}/mouvements', [MouvementController::class, 'index']);
Route::post('/test-post', function () {
    return response()->json(['status' => 'POST ok']);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout']);