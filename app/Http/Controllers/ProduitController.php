<?php

namespace App\Http\Controllers;

use App\Models\Produit;
use Illuminate\Http\Request;

class ProduitController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Produit::all());
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nom' => 'required|string',
            'categorie' => 'required|string',
            'description' => 'nullable|string',
            'stock' => 'required|integer',
            'prix_unitaire' => 'required|numeric',
            'seuil_alerte' => 'required|integer',
        ]);

        $produit = Produit::create($validated);
        return response()->json($produit, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $produit = Produit::findOrFail($id);
        return response()->json($produit);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $produit = Produit::findOrFail($id);

        $validated = $request->validate([
            'nom' => 'sometimes|required|string',
            'categorie' => 'sometimes|required|string',
            'description' => 'nullable|string',
            'stock' => 'sometimes|required|integer',
            'prix_unitaire' => 'sometimes|required|numeric',
            'seuil_alerte' => 'sometimes|required|integer',
        ]);

        $produit->update($validated);
        return response()->json($produit);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $produit = Produit::findOrFail($id);
        $produit->delete();
        return response()->json(null, 204);
    }
}
