package com.mind_your.mind.controllers;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mind_your.mind.dto.response.EnderecoResponseDTO;
import com.mind_your.mind.models.Endereco;
import com.mind_your.mind.service.EnderecoService;

@RestController
@RequestMapping("/enderecos")
public class EnderecoController {

    @Autowired
    private EnderecoService enderecoService;

    @GetMapping("/{cep}")
    public ResponseEntity<EnderecoResponseDTO> getEndereco(@PathVariable("cep") String cep) {
        Optional<EnderecoResponseDTO> endereco = enderecoService.obtemEnderecoPorCep(cep);
        return endereco.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("/logadouro/{cep}")
    public ResponseEntity<Endereco> getLogradouro(@PathVariable("cep") String cep) {
        Optional<Endereco> endereco = enderecoService.obtemLogradouroPorCep(cep);
        return endereco.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }
}
