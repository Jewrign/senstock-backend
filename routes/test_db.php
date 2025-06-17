<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

Route::get('/test-db', function () {
    try {
        DB::connection()->getPdo();
        return response()->json(['status' => 'success', 'message' => 'Database connection successful']);
    } catch (\Exception $e) {
        return response()->json([
            'status' => 'error',
            'message' => $e->getMessage(),
            'code' => $e->getCode()
        ], 500);
    }
});
